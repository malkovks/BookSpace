//
// File name: SavedBooksViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 07.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import SwiftData

@MainActor
final class SavedBooksViewModel: ObservableObject {
    private let dataManager: BooksDataManager
    
    @Published var savedBooks: [SavedBooks] = [] {
        didSet {
            isModelsEmpty = savedBooks.isEmpty
        }
    }
    @Published var isModelsEmpty: Bool = false
    @Published var isPresentAlert: Bool = false
    @Published var deleteSelectedBook: SavedBooks?
    @Published var selectedBook: SavedBooks?
    @Published var navigationPath = NavigationPath()
    
    init(modelContext: ModelContext) {
        self.dataManager = BooksDataManager(context: modelContext)
    }
}

extension SavedBooksViewModel {
    func fetchSavedBooks() {
        savedBooks = dataManager.fetchBooks().filter({ $0.isFavorite })
    }
    
    func remove() {
        guard let deleteSelectedBook else { return }
        dataManager.deleteFromStorage(book: deleteSelectedBook)
    }
    
    func updatePlannedRead(for book: SavedBooks, needToRead: Bool){
        dataManager.togglePlannedToRead(for: book, isPlanned: needToRead)
    }
    
    func updateRating(for book: SavedBooks, rating: Int) {
        dataManager.updateBookRating(for: book, rating: rating)
    }
}
