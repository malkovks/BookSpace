//
// File name: BooksDataManager.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 11.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftData
import WidgetKit

@MainActor
class BooksDataManager {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchBooks() -> [SavedBooks] {
        let fetchDescriptor = FetchDescriptor<SavedBooks>(sortBy: [SortDescriptor(\.createdAt,order: .reverse)])
        return (try? context.fetch(fetchDescriptor)) ?? []
    }
    
    func toggleFavorite(for book: SavedBooks,isFavorite: Bool) {
        book.isFavorite = isFavorite
        saveChanges()
    }
    
    func togglePlannedToRead(for book: SavedBooks, isPlanned: Bool) {
        book.isPlannedToRead = isPlanned
        saveChanges()
    }
    
    func toggleCompleteStatus(for book: SavedBooks, isComplete: Bool) {
        book.isCompleteReaded = isComplete
        saveChanges()
    }
    
    func updateBookRating(for book: SavedBooks, rating: Int){
        book.averageRating = Double(rating)
        saveChanges()
    }
    
    func deleteFromStorage(book: SavedBooks){
        context.delete(book)
        saveChanges()
    }
    
    //update statuses for books
    func updatePlannedBooks(_ book: Book,_ isReadLater: Bool, completion: ((_ result: Status) -> Void)? = nil) {
        let descriptor = FetchDescriptor<SavedBooks>(predicate: #Predicate { plannedBooks in
            plannedBooks.id == book.id
        })
        do {
            if let planned = try context.fetch(descriptor).first {
                let newStatus = !isReadLater
                if planned.isPlannedToRead != newStatus {
                    planned.isPlannedToRead = newStatus
                    updateWidgetData()
                    completion?(.update)
                    print("✅Update existed planned book status updated for \(planned.title)")
                } else {
                    completion?(.warning)
                    print("ℹ️ status is equal as stored property for \(planned.title)")
                }
            } else {
                let plannedBook = SavedBooks(from: book)
                plannedBook.isPlannedToRead = true
                context.insert(plannedBook)
                saveChanges()
                completion?(.success)
                print("✅Create new favorite book")
            }
        } catch {
            completion?(.error)
            print("❌Error updating planned books: \(error)")
        }
    }
    
    func updateFavoriteBooks(_ book: Book, _ isFavorite: Bool, completion: ((_ result: Status) -> Void)? = nil) {
        let descriptor = FetchDescriptor<SavedBooks>(predicate: #Predicate { favBooks in
            favBooks.id == book.id
        })
        do {
            if let fav = try context.fetch(descriptor).first {
                let newStatus = !isFavorite
                if fav.isFavorite != newStatus {
                    fav.isFavorite = newStatus
                    updateWidgetData()
                    completion?(.update)
                    print("✅Update existed planned book status updated for \(fav.title)")
                } else {
                    completion?(.warning)
                    print("ℹ️ status is equal as stored property for \(fav.title)")
                }
            } else {
                let favBook = SavedBooks(from: book)
                favBook.isFavorite = true
                context.insert(favBook)
                saveChanges()
                completion?(.success)
                print("✅Create new favorite book")
            }
        } catch {
            completion?(.error)
            print("❌Error updating planned books: \(error)")
        }
    }
}
private extension BooksDataManager {
    
    private func saveChanges() {
        try? context.save()
        updateWidgetData()
    }
    
    private func updateWidgetData() {
        let books = fetchBooks()
        let favoriteBooksCount = books.filter { $0.isFavorite }.count
        let toReadCount = books.filter { $0.isPlannedToRead }.count
        
        let userDefaults = UserDefaults(suiteName: "group.malkov.ks.BookSpace")
        userDefaults?.set(favoriteBooksCount, forKey: "favoritesCount")
        print("favoriteBooksCount: \(userDefaults!.value(forKey: "favoritesCount") as! Int)")
        userDefaults?.set(toReadCount, forKey: "toReadCount")
        print("to Read Count: \(userDefaults!.value(forKey: "toReadCount") as! Int)")
        WidgetCenter.shared.reloadAllTimelines()
    }
}
