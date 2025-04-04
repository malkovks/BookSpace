//
// File name: PlannedBooks.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 03.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import Foundation
import SwiftData

@Model
class PlannedBooks {
    @Attribute(.unique) var id: String
    var title: String
    var _description: String
    var authors: String
    var category: String
    var language: String
    var publisher: String
    var publishedDate: String
    var pagesCount: Int
    var maturityRating: String
    var averageRating: Double?
    var ratingsCount: Double?
    var storeLink: String
    var marketLink: String
    
    init(from book: Book) {
        self.id = book.id
        self.title = book.volumeInfo.title
        self._description = book.volumeInfo.description  ?? ""
        self.authors = book.volumeInfo.authors?.joined(separator: ", ") ?? ""
        self.category = book.volumeInfo.categories?.joined(separator: ", ") ?? ""
        self.language = book.volumeInfo.language
        self.publisher = book.volumeInfo.publisher ?? ""
        self.publishedDate = book.volumeInfo.publishedDate ?? ""
        self.pagesCount = book.volumeInfo.pageCount 
        self.maturityRating = book.volumeInfo.maturityRating
        self.averageRating = book.volumeInfo.averageRating  ?? 0
        self.ratingsCount = book.volumeInfo.ratingsCount ?? 0
        self.storeLink = book.volumeInfo.canonicalVolumeLink
        self.marketLink = book.accessInfo.webReaderLink
    }
}
