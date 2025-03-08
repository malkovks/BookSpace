//
// File name: SavedBooks.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 03.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import Foundation
import SwiftData

@Model
class SavedBooks {
    @Attribute(.unique) var id: String
    var title: String
    var subtitle: String
    var _description: String
    var authors: String
    var category: String
    var language: String
    var publisher: String
    var publishedDate: String
    var coverURL: String
    var pagesCount: Int
    var maturityRating: String
    var averageRating: Double?
    var ratingsCount: Double?
    var storeLink: String
    var marketLink: String
    var createdAt: Date
    var isCompleteReaded: Bool = false
    var isPlannedToRead: Bool = false
    var isFavorite: Bool = false
    
    init(from book: Book,isFavorite: Bool) {
        self.id = book.id
        self.title = book.volumeInfo.title
        self.subtitle = book.volumeInfo.subtitle ?? ""
        self._description = book.volumeInfo.description
        self.authors = book.volumeInfo.authors.joined(separator: ", ")
        self.category = book.volumeInfo.categories.joined(separator: ", ")
        self.language = book.volumeInfo.language
        self.publisher = book.volumeInfo.publisher
        self.publishedDate = book.volumeInfo.publishedDate
        self.pagesCount = book.volumeInfo.pageCount
        self.maturityRating = book.volumeInfo.maturityRating
        self.averageRating = book.volumeInfo.averageRating
        self.ratingsCount = book.volumeInfo.ratingsCount
        self.storeLink = book.volumeInfo.canonicalVolumeLink
        self.marketLink = book.accessInfo.webReaderLink
        self.coverURL = book.volumeInfo.imageLinks.thumbnail
        self.createdAt = Self.currentDateInLocalTimeFormat()
    }
    
    
    
    private static func currentDateInLocalTimeFormat() -> Date {
        let now = Date()
        let timeZone = TimeZone.current
        let secondsFromGMT = timeZone.secondsFromGMT(for: now)
        return now.addingTimeInterval(TimeInterval(secondsFromGMT))
    }
}
