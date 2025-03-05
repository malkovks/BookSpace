//
// File name: BookCollectionViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import SwiftData


final class BookCollectionViewModel: ObservableObject {
    var modelContext: ModelContext
    var isSearchFieldVisible = false
    @Published var searchText: String = ""
    
    @Published var isFilterOpened: Bool = false
    @Published var selectedFilter: FilterCategories = .ebooks {
        didSet {
            if selectedFilter != oldValue {
                applyFilter(selectedFilter)
            }
        }
    }
    
    @Published var searchResults: [String] = ["SwiftUI", "UIKit", "Combine", "Core Data"]
    
    @Published var books: [Book] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedBook: Book?
    @Published var navigationPath = NavigationPath()
    
    init(modelContext: ModelContext){
        self.modelContext = modelContext
    }
    
    private let api = GoogleBooksApi()
}

extension BookCollectionViewModel {
    func shareSelectedBook(_ book: Book){
        print("Present UIActivityController for sharing item")
    }
}

extension BookCollectionViewModel {
    
    func toggleFutureReading(book: Book){
        if isPlanned(book: book) {
            removeFromPlanning(book: book)
        } else {
            addToPlanned(book: book)
        }
    }
    
    func isPlanned(book: Book) -> Bool {
        let descriptor = FetchDescriptor<PlannedBooks>(predicate: #Predicate { plannedBook in
            plannedBook.id == book.id
        })
        if let fav = try? modelContext.fetch(descriptor),
           let _ = fav.first { return true }
        return false
    }
    
    private func addToPlanned(book: Book) {
        guard !isPlanned(book: book) else { return }
        
        let plannedBook = PlannedBooks(from: book)
        modelContext.insert(plannedBook)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving planned book: \(error)")
        }
        objectWillChange.send()
    }
    
    private func removeFromPlanning(book: Book) {
        guard isPlanned(book: book) else { return }
        
        let descriptor = FetchDescriptor<PlannedBooks>(predicate: #Predicate { plannedBook in
            plannedBook.id == book.id
        })
        
        if let plannedBook = try? modelContext.fetch(descriptor).first {
            modelContext.delete(plannedBook)
            
            do {
                try modelContext.save()
            } catch {
                print("Error removing planned book: \(error)")
            }
            objectWillChange.send()
        }
        
        
    }
}

extension BookCollectionViewModel {
    func isFavorite(book: Book) -> Bool {
        let descriptor = FetchDescriptor<SavedBooks>(predicate: #Predicate { savedBook in
            savedBook.id == book.id
        })
        if let fav = try? modelContext.fetch(descriptor),
           let _ = fav.first { return true }
        return false
    }
    
    private func addToFavorites(book: Book) {
        guard !isFavorite(book: book) else { return }
        
        let savedBook = SavedBooks(from: book)
        modelContext.insert(savedBook)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving favorite book: \(error)")
        }
        objectWillChange.send()
    }
    
    private func removeFromFavorite(book: Book) {
        let descriptor = FetchDescriptor<SavedBooks>(predicate: #Predicate { savedBook in
            savedBook.id == book.id
        })
        if let fav = try? modelContext.fetch(descriptor).first {
            modelContext.delete(fav)
            
            do {
                try modelContext.save()
            } catch {
                print("Error Deleting favorite book: \(error)")
            }
            objectWillChange.send()
        } else {
            print("Favorite book not found.")
        }
    }
    
    func toggleFavorite(book: Book) {
        if isFavorite(book: book) {
            removeFromFavorite(book: book)
        } else {
            addToFavorites(book: book)
        }
    }
}
    
extension BookCollectionViewModel {
        
    
    @MainActor
    func fetchBooks() async {
        isLoading = true
        errorMessage = nil
        

//        do {
//            //query request is default
//            let response = try await api.fetchData(query: "mafia")
//            books = response.items ?? []
//            print("Fetched \(books.count) books.")
//        } catch {
//            errorMessage = error.localizedDescription
//            print("Fetching failed: \(error)")
//        }
             
         
        do {
            
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2 sec test request
        } catch {
            errorMessage = "Failed to simulate loading"
        }
        books = bookMockModel
        isLoading = false
    }
    
    func applyFilter(_ filter: FilterCategories){
        selectedFilter = filter
        Task {
            await fetchBooks()
        }
    }
}



