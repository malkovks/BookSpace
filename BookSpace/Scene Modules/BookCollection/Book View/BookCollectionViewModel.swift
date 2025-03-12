//
// File name: BookCollectionViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import SwiftData

@MainActor
final class BookCollectionViewModel: ObservableObject {
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
    @Published var storagedBooks: [SavedBooks] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedBook: Book?
    @Published var navigationPath = NavigationPath()
    
    init(modelContext: ModelContext){
        self.dataManager = BooksDataManager(context: modelContext)
        loadStoragedData()
    }
    
    private let api = GoogleBooksApi()
    private let dataManager: BooksDataManager
}

extension BookCollectionViewModel {

    func updatePlannedBooks(_ book: Book,_ isReadLater: Bool){
        dataManager.updatePlannedBooks(book, isReadLater)
        loadStoragedData()
    }
    
    func isPlanned(book: Book) -> Bool {
        if let index = storagedBooks.firstIndex(where: { $0.id == book.id }) {
            return storagedBooks[index].isPlannedToRead
        } else {
            return false
        }
    }
    
    private func loadStoragedData() {
        storagedBooks = dataManager.fetchBooks()
    }
}

extension BookCollectionViewModel {
    func isFavorite(book: Book) -> Bool {
        if let index = storagedBooks.firstIndex(where: { $0.id == book.id }) {
            return storagedBooks[index].isFavorite
        } else {
            return false
        }
    }
    
    func updateFavoriteBooks(_ book: Book,_ isFav: Bool) {
        dataManager.updateFavoriteBooks(book, isFav)
        loadStoragedData()
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



