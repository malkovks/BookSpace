//
// File name: ReadLaterViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 09.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI
import SwiftData

@MainActor
class ReadLaterViewModel: ObservableObject {
    
    private let dataManager: BooksDataManager
    
    @Published var books: [SavedBooks] = [] {
        didSet {
            isModelsEmpty = books.isEmpty
        }
    }
    @Published var isEditing: Bool = false
    @Published var isModelsEmpty: Bool = false
    @Published var isStartToDelete: Bool = false
    @Published var selectedItems: Set<SavedBooks> = []
    
    init(modelContext: ModelContext) {
        self.dataManager = BooksDataManager(context: modelContext)
    }
}

extension ReadLaterViewModel {
    
    func deleteSelectedBooks() {
        for book in selectedItems {
            dataManager.deleteFromStorage(book: book)
        }
    }
    
    func fetchReadLaterBooks() {
        books = dataManager.fetchBooks().filter({ $0.isPlannedToRead })
    }
    
    func updateCompleteStatus(for book: SavedBooks,isComplete: Bool){
        dataManager.toggleCompleteStatus(for: book, isComplete: isComplete)
    }
    
    func updatePlannedStatus(for book: SavedBooks,isPlanned: Bool){
        dataManager.togglePlannedToRead(for: book, isPlanned: isPlanned)
    }
    
    func updateFavStatus(for book: SavedBooks, isFavorite: Bool) {
        dataManager.toggleFavorite(for: book, isFavorite: isFavorite)
    }
}
