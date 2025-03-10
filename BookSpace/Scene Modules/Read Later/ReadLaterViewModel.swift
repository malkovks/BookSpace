//
// File name: ReadLaterViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 09.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI
import SwiftData

class ReadLaterViewModel: ObservableObject {
    var modelContext: ModelContext
    
    @Published var books: [SavedBooks] = []
    @Published var isModelsEmpty: Bool = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
}

extension ReadLaterViewModel {
    
    func fetchReadLaterBooks() {
        var descriptor = FetchDescriptor<SavedBooks>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        descriptor.predicate = #Predicate { savedBook in
            savedBook.isPlannedToRead
        }
        if let books = try? modelContext.fetch(descriptor) {
            self.books = books
            isModelsEmpty = books.isEmpty
        } else {
            self.books = []
            isModelsEmpty = true
        }
    }
    
    func updateCompleteStatus(for book: SavedBooks,isComplete: Bool){
        book.isCompleteReaded = isComplete
        do {
            try modelContext.save()
            fetchReadLaterBooks()
        } catch {
            print("Error updating complete reader status: \(error)")
        }
    }
    
    func updatePlannedStatus(for book: SavedBooks,isPlanned: Bool){
        book.isPlannedToRead = isPlanned
        do {
            try modelContext.save()
            fetchReadLaterBooks()
        } catch {
            print("Error updating planned to read status: \(error)")
        }
    }
    
    func updateFavStatus(for book: SavedBooks, isFavorite: Bool) {
        book.isFavorite = isFavorite
        do {
            try modelContext.save()
            fetchReadLaterBooks()
        } catch {
            print("Error updating saved status: \(error)")
        }
    }
}
