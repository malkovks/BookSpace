//
// File name: BookCollectionViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import SwiftData
import Combine

@MainActor
final class BookCollectionViewModel: ObservableObject {
    @Published var isSearchFieldVisible = false {
        didSet {
            if !isSearchFieldVisible {
                searchTask?.cancel()
                searchTask = nil
            }
        }
    }
    @Published var searchText: String = "" {
        didSet {
            debounceSearch()
        }
    }
    
    @Published var selectedFilter: FilterCategories = .ebooks {
        didSet {
            if selectedFilter != oldValue {
                applyFilter(selectedFilter)
            }
        }
    }
    
    @Published var isFilterOpened: Bool = false {
        didSet {
            if !isFilterOpened {
                filterTask?.cancel()
                filterTask = nil
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
    @Published var showAlertView: Bool = false
    @Published var status: Status = .error
    @Published var message: String?
    
    init(modelContext: ModelContext){
        self.dataManager = BooksDataManager(context: modelContext)
        loadStoragedData()
    }
    
    private let api = GoogleBooksApi()
    private var searchTask: Task<Void, Never>? = nil
    private var filterTask: Task<Void, Never>? = nil
    private let dataManager: BooksDataManager
}

extension BookCollectionViewModel {

    func updatePlannedBooks(_ book: Book,_ isReadLater: Bool,completion: ((_ result: Status) -> Void)? = nil){
        dataManager.updatePlannedBooks(book, isReadLater,completion: completion)
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
    
    func updateFavoriteBooks(_ book: Book,_ isFav: Bool,completion: ((_ result: Status) -> Void)? = nil) {
        dataManager.updateFavoriteBooks(book, isFav,completion: completion)
        loadStoragedData()
    }
}
    
extension BookCollectionViewModel {

    func debounceSearch() {
        searchTask?.cancel()
        searchTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard !Task.isCancelled else { return }
            await fetchBooks(query: searchText)
        }
    }
    
    func applyFilter(_ filter: FilterCategories){
        filterTask?.cancel()
        filterTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard !Task.isCancelled else { return }
            selectedFilter = filter
            await fetchBooks()
        } 
    }
    
    @MainActor
    func fetchBooks(query: String = "mafia") async {
        isLoading = true
        errorMessage = nil
        

//        do {
//            //query request is default
//            let response = try await api.fetchData(query: query, filter: selectedFilter)
//            books = response.items ?? []
//            print("Fetched \(books.count) books.")
//        } catch {
//            errorMessage = error.localizedDescription
//            print("Fetching failed: \(error)")
//        }
//             
//         
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2 sec test request
        } catch {
            errorMessage = "Failed to simulate loading"
        }
        books = bookMockModel
        
        isLoading = false
    }
    
    
}



