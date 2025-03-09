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
    @Published var isPresentAlert: Bool = false
    @Published var deleteSelectedBook: SavedBooks?
    @Published var selectedBook: SavedBooks?
    @Published var navigationPath = NavigationPath()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
}

extension SavedBooksViewModel {
    func fetchSavedBooks() {
        var descriptor = FetchDescriptor<SavedBooks>(sortBy: [SortDescriptor(\.createdAt,order: .reverse)])
        descriptor.predicate = #Predicate { savedBook in
            savedBook.isFavorite == true
        }
        if let books = try? modelContext.fetch(descriptor) {
            savedBooks = books
            isModelsEmpty = books.isEmpty
        } else {
            savedBooks = []
            isModelsEmpty = true
        }
    }
    
    func remove() {
        guard let deleteSelectedBook else { return }
        modelContext.delete(deleteSelectedBook)
        do {
            try modelContext.save()
            fetchSavedBooks()
        } catch {
            print("Error delete book: \(error)")
        }
    }
    
    func updatePlannedRead(for book: SavedBooks, needToRead: Bool){
        book.isPlannedToRead = needToRead
        do {
            try modelContext.save()
            fetchSavedBooks()
        } catch {
            print("Error update read status: \(error)")
        }
    }
    
    func updateCompleteReading(for book: SavedBooks,_ isComplete: Bool) {
        book.isCompleteReaded = isComplete
        do {
            try modelContext.save()
            fetchSavedBooks()
        } catch {
            print("Error update read completing: \(error)")
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
