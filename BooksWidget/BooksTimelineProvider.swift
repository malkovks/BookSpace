//
// File name: BooksTimelineProvider.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 11.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import WidgetKit
import SwiftUI
import SwiftData

@MainActor
struct BooksTimelineProvider: TimelineProvider {
    let dataManager: BooksDataManager
    
    init(modelContext: ModelContext) {
        self.dataManager = BooksDataManager(context: modelContext)
    }
    
    nonisolated func placeholder(in context: Context) -> BooksEntry {
        BooksEntry(date: Date(), favoriteCount: 5, plannedCount: 2)
    }
    
    nonisolated func getSnapshot(in context: Context, completion: @escaping (BooksEntry) -> Void) {
        Task { @MainActor in
            let favCount = fetchFavoriteBooksCount()
            let plannedCount = fetchPlannedBooksCount()
            let entry = BooksEntry(date: Date(), favoriteCount: favCount, plannedCount: plannedCount)
            
            completion(entry)
        }
    }
    
    nonisolated func getTimeline(in context: Context, completion: @escaping (Timeline<BooksEntry>) -> Void) {
        Task { @MainActor in
            let favBooks = fetchFavoriteBooksCount()
            let plannedBooks = fetchPlannedBooksCount()
            
            let entry = BooksEntry(date: Date(), favoriteCount: favBooks, plannedCount: plannedBooks)
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
            completion(timeline)
        }
    }
    
    private func fetchFavoriteBooksCount() -> Int {
        let books = dataManager.fetchBooks().filter { $0.isFavorite }
        return books.count
    }
    
    private func fetchPlannedBooksCount() -> Int {
        let books = dataManager.fetchBooks().filter { $0.isPlannedToRead }
        return books.count
    }
}
