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



