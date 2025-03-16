//
// File name: BookIdentifiable.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 02.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import Foundation



struct BookIdentifiable: Hashable {
    
    let book: Book
    func hash(into hasher: inout Hasher) {
        hasher.combine(book.id)
    }
    
    static func == (lhs: BookIdentifiable, rhs: BookIdentifiable) -> Bool {
        lhs.book.id == rhs.book.id
    }
}

struct BookPDFIdentifiable: Hashable {
    let pdf: SavedPDF
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(pdf.id)
    }
    
    static func == (lhs: BookPDFIdentifiable, rhs: BookPDFIdentifiable) -> Bool {
        lhs.pdf.id == rhs.pdf.id
    }
}

extension Book {
    init(_ book: SavedBooks) {
        let volume = Book.VolumeInfo(title: book.title, subtitle: book.subtitle, authors: [book.authors], publisher: book.publisher, description: book._description, publishedDate: book.publishedDate, pageCount: book.pagesCount, printType: "", categories: [book.category], averageRating: book.averageRating, ratingsCount: book.ratingsCount, maturityRating: book.maturityRating, allowAnonLogging: false, contentVersion: "", imageLinks: Book.VolumeInfo.ImageLinks.init(smallThumbnail: "", thumbnail: book.coverURL), language: book.language, previewLink: "", infoLink: "", canonicalVolumeLink: book.storeLink)
        self.kind = ""
        self.etag = ""
        self.volumeInfo = volume
        self.id = book.id
        self.selfLink = ""
        self.saleInfo = .init(country: "", saleability: "", isEbook: false)
        self.accessInfo = .init(country: "", epub: .init(isAvailable: false, acsTokenLink: ""), webReaderLink: book.marketLink)
    }
}
