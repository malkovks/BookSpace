//
// File name: Book MockModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 02.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

let bookMockModel: [Book] = [
    Book(
        kind: "books#volume",
        id: "12345",
        etag: "abc123",
        selfLink: "https://www.googleapis.com/books/v1/volumes/12345",
        volumeInfo: Book.VolumeInfo(
            title: "The Great Gatsby",
            subtitle: "A Novel",
            authors: ["F. Scott Fitzgerald"],
            publisher: "Scribner",
            publishedDate: "1925-04-10",
            description: "A classic novel about the American Dream.",
            pageCount: 180,
            printType: "BOOK",
            categories: ["Fiction", "Classic"],
            averageRating: 4,
            ratingsCount: 1000,
            maturityRating: "NOT_MATURE",
            allowAnonLogging: true,
            contentVersion: "1.0.0",
            imageLinks: Book.VolumeInfo.ImageLinks(
                smallThumbnail: "http://example.com/small_thumb",
                thumbnail: "http://example.com/thumb"
            ),
            language: "en",
            previewLink: "http://example.com/preview",
            infoLink: "http://example.com/info",
            canonicalVolumeLink: "http://example.com/canonical"
        ),
        saleInfo: Book.SaleInfo(
            country: "US",
            saleability: "FOR_SALE",
            isEbook: true
        ), accessInfo: Book.AccessInfo(country: "Ru", epub: .init(isAvailable: true, acsTokenLink: "http://example.com/preview"), webReaderLink: "http://example.com/preview")
    ),
    Book(
       kind: "books#volume",
       id: "67890",
       etag: "def456",
       selfLink: "https://www.googleapis.com/books/v1/volumes/67890",
       volumeInfo: Book.VolumeInfo(
           title: "1984",
           subtitle: nil,
           authors: ["George Orwell"],
           publisher: "Secker & Warburg",
           publishedDate: "1949-06-08",
           description: "A dystopian novel about totalitarianism.",
           pageCount: 328,
           printType: "BOOK",
           categories: ["Fiction", "Dystopian"],
           averageRating: nil,
           ratingsCount: nil,
           maturityRating: "NOT_MATURE",
           allowAnonLogging: true,
           contentVersion: "1.0.0",
           imageLinks: Book.VolumeInfo.ImageLinks(
               smallThumbnail: "http://example.com/small_thumb",
               thumbnail: "http://example.com/thumb"
           ),
           language: "en",
           previewLink: "http://example.com/preview",
           infoLink: "http://example.com/info",
           canonicalVolumeLink: "http://example.com/canonical"
       ),
       saleInfo: Book.SaleInfo(
           country: "US",
           saleability: "FOR_SALE",
           isEbook: true
       ), accessInfo: Book.AccessInfo(country: "Ru", epub: .init(isAvailable: true, acsTokenLink: "http://example.com/preview"), webReaderLink: "http://example.com/preview")
   ),
    Book(
        kind: "books#volume",
        id: "11223",
        etag: "ghi789",
        selfLink: "https://www.googleapis.com/books/v1/volumes/11223",
        volumeInfo: Book.VolumeInfo(
            title: "The Lord of the Rings",
            subtitle: "The Fellowship of the Ring",
            authors: ["J.R.R. Tolkien", "Christopher Tolkien"],
            publisher: "Allen & Unwin",
            publishedDate: "1954-07-29",
            description: "An epic fantasy adventure.",
            pageCount: 423,
            printType: "BOOK",
            categories: ["Fantasy", "Adventure"],
            averageRating: 5,
            ratingsCount: 5000,
            maturityRating: "NOT_MATURE",
            allowAnonLogging: true,
            contentVersion: "1.0.0",
            imageLinks: Book.VolumeInfo.ImageLinks(
                smallThumbnail: "http://example.com/small_thumb",
                thumbnail: "http://example.com/thumb"
            ),
            language: "en",
            previewLink: "http://example.com/preview",
            infoLink: "http://example.com/info",
            canonicalVolumeLink: "http://example.com/canonical"
        ),
        saleInfo: Book.SaleInfo(
            country: "US",
            saleability: "FOR_SALE",
            isEbook: true
        ), accessInfo: Book.AccessInfo(country: "Ru", epub: .init(isAvailable: true, acsTokenLink: "http://example.com/preview"), webReaderLink: "http://example.com/preview")
    ),
    Book(
        kind: "books#volume",
        id: "44556",
        etag: "jkl012",
        selfLink: "https://www.googleapis.com/books/v1/volumes/44556",
        volumeInfo: Book.VolumeInfo(
            title: "Pride and Prejudice",
            subtitle: nil,
            authors: ["Jane Austen"],
            publisher: "T. Egerton, Whitehall",
            publishedDate: "1813-01-28",
            description: "A romantic novel of manners.",
            pageCount: 279,
            printType: "BOOK",
            categories: ["Romance", "Classic"],
            averageRating: 4,
            ratingsCount: 2000,
            maturityRating: "NOT_MATURE",
            allowAnonLogging: true,
            contentVersion: "1.0.0",
            imageLinks: Book.VolumeInfo.ImageLinks(
                smallThumbnail: "",
                thumbnail: ""
            ),
            language: "en",
            previewLink: "http://example.com/preview",
            infoLink: "http://example.com/info",
            canonicalVolumeLink: "http://example.com/canonical"
        ),
        saleInfo: Book.SaleInfo(
            country: "US",
            saleability: "FOR_SALE",
            isEbook: true
        ), accessInfo: Book.AccessInfo(country: "Ru", epub: .init(isAvailable: true, acsTokenLink: "http://example.com/preview"), webReaderLink: "http://example.com/preview")
    ),
    Book(
        kind: "books#volume",
        id: "77889",
        etag: "mno345",
        selfLink: "https://www.googleapis.com/books/v1/volumes/77889",
        volumeInfo: Book.VolumeInfo(
            title: "To Kill a Mockingbird",
            subtitle: nil,
            authors: ["Harper Lee"],
            publisher: "J.B. Lippincott & Co.",
            publishedDate: "1960-07-11",
            description: "A novel about racial injustice.",
            pageCount: 281,
            printType: "BOOK",
            categories: ["Fiction", "Classic"],
            averageRating: 4,
            ratingsCount: 3000,
            maturityRating: "NOT_MATURE",
            allowAnonLogging: true,
            contentVersion: "1.0.0",
            imageLinks: Book.VolumeInfo.ImageLinks(
                smallThumbnail: "http://example.com/small_thumb",
                thumbnail: "http://example.com/thumb"
            ),
            language: "en",
            previewLink: "http://example.com/preview",
            infoLink: "http://example.com/info",
            canonicalVolumeLink: "http://example.com/canonical"
        ),
        saleInfo: Book.SaleInfo(
            country: "US",
            saleability: "NOT_FOR_SALE",
            isEbook: false
        ), accessInfo: Book.AccessInfo(country: "Ru", epub: .init(isAvailable: true, acsTokenLink: "http://example.com/preview"), webReaderLink: "http://example.com/preview")
    )
]
