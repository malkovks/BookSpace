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

    func updatePlannedBooks(_ book: Book,_ isReadLater: Bool? = nil){
        
        let descriptor = FetchDescriptor<SavedBooks>(predicate: #Predicate { savedBook in
            savedBook.id == book.id
        })
        if let planned = try? modelContext.fetch(descriptor).first {
            planned.isPlannedToRead = isReadLater ?? false
            do {
                try modelContext.save()
                print("✅ Saved changes")
            } catch {
                print("Error updating data \(error)")
            }
            objectWillChange.send()
        } else {
            let plannedBook = SavedBooks(from: book)
            plannedBook.isPlannedToRead = true
            modelContext.insert(plannedBook)
            do {
                try modelContext.save()
                print("✅ Saved new model")
            } catch {
                print("Error updating data \(error)")
            }
            objectWillChange.send()
        }
    }
    
    func isPlanned(book: Book) -> Bool {
        let descriptor = FetchDescriptor<SavedBooks>(predicate: #Predicate { plannedBook in
            plannedBook.id == book.id && plannedBook.isPlannedToRead
        })
        if let fav = try? modelContext.fetch(descriptor),
           let _ = fav.first { return true }
        return false
    }
}

extension BookCollectionViewModel {
    func isFavorite(book: Book) -> Bool {
        let descriptor = FetchDescriptor<SavedBooks>(predicate: #Predicate { savedBook in
            savedBook.id == book.id && savedBook.isFavorite
        })
        if let fav = try? modelContext.fetch(descriptor),
           let _ = fav.first { return true }
        return false
    }
    
    func updateFavoriteBooks(_ book: Book,_ isFav: Bool? = nil) {
        let descriptor = FetchDescriptor<SavedBooks>(predicate: #Predicate { savedBook in
            savedBook.id == book.id
        })
        if let fav = try? modelContext.fetch(descriptor).first {
            fav.isFavorite = isFav ?? !isFavorite(book: book)
            do {
                try modelContext.save()
                print("✅Update favorite books items")
            } catch {
                print("❗️Error saving updates for favorite books")
            }
            objectWillChange.send()
        } else {
            let favBook = SavedBooks(from: book)
            favBook.isFavorite = true
            modelContext.insert(favBook)
            do {
                try modelContext.save()
                print("✅Add favorite books items")
            } catch {
                print("❗️Error saving updates for favorite books")
            }
            objectWillChange.send()
        }
    }
}
    
extension BookCollectionViewModel {
        
    
    @MainActor
    func fetchBooks() async {
        isLoading = true
        errorMessage = nil
        

        do {
            //query request is default
            let response = try await api.fetchData(query: "mafia")
            books = response.items ?? []
            print("Fetched \(books.count) books.")
        } catch {
            errorMessage = error.localizedDescription
            print("Fetching failed: \(error)")
        }
             
//         
//        do {
//            
//            try await Task.sleep(nanoseconds: 2_000_000_000) // 2 sec test request
//        } catch {
//            errorMessage = "Failed to simulate loading"
//        }
//        books = bookMockModel
        
        isLoading = false
    }
    
    func applyFilter(_ filter: FilterCategories){
        selectedFilter = filter
        Task {
            await fetchBooks()
        }
    }
}



