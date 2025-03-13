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
    @Published var isEditing: Bool = false {
        didSet {
            if !isEditing {
                selectedItems.removeAll()
            }
        }
    }
    @Published var navigationPath = NavigationPath()
    @Published var selectedBook: SavedBooks?
    @Published var isModelsEmpty: Bool = false
    @Published var isStartToDelete: Bool = false
    
    @Published var selectedItems: Set<SavedBooks> = [] {
        didSet {
            print("selected items is \(selectedItems.count)")
        }
    }
    
    private var deletionWorkItem: DispatchWorkItem?
    
    init(modelContext: ModelContext) {
        self.dataManager = BooksDataManager(context: modelContext)
    }
}

//MARK: - Timer methods
extension ReadLaterViewModel {
    private func scheduleDeletion(_ book: SavedBooks){
        cancelDeletion()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.acceptDeletion(book)
            sleep(1)
            self?.fetchReadLaterBooks()
        }
        deletionWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem)
    }
    
    private func cancelDeletion(){
        deletionWorkItem?.cancel()
        deletionWorkItem = nil
    }
    
    private func acceptDeletion(_ book: SavedBooks){
        dataManager.deleteFromStorage(book: book)
    }
}

extension ReadLaterViewModel {
    
    func addBook(_ book: SavedBooks){
        selectedItems.insert(book)
    }
    
    func removeBook(_ book: SavedBooks){
        selectedItems.remove(book)
    }
    
    func deleteSelectedBooks() {
        for book in selectedItems {
            dataManager.deleteFromStorage(book: book)
        }
        isEditing = false
        isStartToDelete = false
    }
    
    func fetchReadLaterBooks() {
        books = dataManager.fetchBooks().filter({ $0.isPlannedToRead })
    }
    
    func updateCompleteStatus(for book: SavedBooks,isComplete: Bool){
        dataManager.toggleCompleteStatus(for: book, isComplete: isComplete)
    }
    
    func updatePlannedStatus(for book: SavedBooks,isPlanned: Bool){
        dataManager.togglePlannedToRead(for: book, isPlanned: isPlanned)
        if !isPlanned {
            scheduleDeletion(book)
        } else {
            cancelDeletion()
        }
    }
    
    func updateFavStatus(for book: SavedBooks, isFavorite: Bool) {
        dataManager.toggleFavorite(for: book, isFavorite: isFavorite)
    }
}
