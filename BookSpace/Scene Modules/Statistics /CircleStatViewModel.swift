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
    
    private let bookManager: BooksDataManager
    
    init(bookManager: BooksDataManager) {
        self.bookManager = bookManager
    }
    
    func fetchBoksStats() async {
        let books = await bookManager.fetchBooks()
        let (favorites, planned, read) = (
            books.filter({ $0.isFavorite }).count,
            books.filter({ $0.isPlannedToRead }).count,
            books.filter({ $0.isCompleteReaded }).count
        )
        if favorites == 0 && planned == 0 && read == 0 {
            DispatchQueue.main.async {
                self.stats = BookStat.fromStats(favorites: 0, planned: 0, read: 0)
                self.isLoading = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            
            self.stats = BookStat.fromStats(favorites: favorites, planned: planned, read: read)
            self.isLoading = false
        }
    }
}
