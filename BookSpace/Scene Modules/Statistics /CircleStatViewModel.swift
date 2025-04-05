//
// File name: CircleStatViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 04.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

@Observable
class CircleStatViewModel: ObservableObject {
    var navigationPath = NavigationPath()
    var isLoading: Bool = true
    var stats: [BookStat] = []
    var filteredStats: [BookStat] = []
    var categories: [BookStat.BookCategory] = [.favorite,.planned,.read] {
        didSet {
            updateFilterStats()
        }
    }
    var isOpenFilter: Bool = false
    
    private let bookManager: BooksDataManager
    
    init(bookManager: BooksDataManager) {
        self.bookManager = bookManager
    }
    
    func updateFilterStats(){
        filteredStats = stats.filter({ categories.contains($0.category) })
    }
    
    func toggleCategories(_ category: BookStat.BookCategory) {
        if categories.contains(category) {
            categories.removeAll { $0 == category }
        } else {
            categories.append(category)
        }
    }
    
    func fetchBooksStats() async {
        isLoading = true
        let books = await bookManager.fetchBooks()
        let (favorites, planned, read) = (
            books.filter({ $0.isFavorite }).count,
            books.filter({ $0.isPlannedToRead }).count,
            books.filter({ $0.isCompleteReaded }).count
        )
        if favorites == 0 && planned == 0 && read == 0 {
            DispatchQueue.main.async {
                self.stats = BookStat.fromStats(favorites: 0, planned: 0, read: 0)
                self.updateFilterStats()
                self.isLoading = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.stats = BookStat.fromStats(favorites: favorites, planned: planned, read: read)
            self.updateFilterStats()
            self.isLoading = false
        }
    }
}
