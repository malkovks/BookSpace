//
// File name: SavedBooksViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 07.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import SwiftData

final class SavedBooksViewModel: ObservableObject {
    var modelContext: ModelContext
    
    @Published var savedBooks: [SavedBooks] = []
    @Published var isModelsEmpty: Bool = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchSavedBooks()
    }
}

extension SavedBooksViewModel {
    func fetchSavedBooks() {
        let descriptor = FetchDescriptor<SavedBooks>(sortBy: [SortDescriptor(\.createdAt,order: .reverse)])
        if let books = try? modelContext.fetch(descriptor) {
            savedBooks = books
            isModelsEmpty = books.isEmpty
        } else {
            savedBooks = []
            isModelsEmpty = true
        }
    }
    
    func remove(book: SavedBooks) {
        modelContext.delete(book)
        do {
            try modelContext.save()
            fetchSavedBooks()
        } catch {
            print("Error delete book: \(error)")
        }
    }
    
    func updateRating(for book: SavedBooks, rating: Int) {
        book.averageRating = Double(rating)
        do {
            try modelContext.save()
            fetchSavedBooks()
        } catch {
            print("Error update rating: \(error)")
        }
    }
    
    func isEmptySavedBooks() -> Bool {
        let descriptor = FetchDescriptor<SavedBooks>()
        do {
            let books = try modelContext.fetch(descriptor)
            return books.isEmpty
        } catch {
            print("Error fetching books: \(error)")
            return true
        }
    }
}
