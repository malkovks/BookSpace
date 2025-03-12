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
        selfLink: "https://www.googleapis.com/books/v1/volumes/Ru58xAaPZxcC",
        volumeInfo: Book.VolumeInfo(
            title: "The Twelve Chairs",
            subtitle: "A Novel",
            authors: ["Ilf Petrov", "Evgeniy Petrov"],
            publisher: "ScriNorthwestern University Pressbner",
            description: "Ostap Bender is an unemployed con artist living by his wits in postrevolutionary Soviet Russia. He joins forces with Ippolit Matveyevich Vorobyaninov, a former nobleman who has returned to his hometown to find a cache of missing jewels which were hidden in some chairs that have been appropriated by the Soviet authorities. The search for the bejeweled chairs takes these unlikely heroes from the provinces to Moscow to the wilds of Soviet Georgia and the Trans-caucasus mountains; on their quest they encounter a wide variety of characters: from opportunistic Soviet bureaucrats to aging survivors of the prerevolutionary propertied classes, each one more selfish, venal, and ineffective than the one before.", publishedDate: "1997",
            pageCount: 180,
            printType: "BOOK",
            categories: ["Fiction", "Classic"],
            averageRating: 4,
            ratingsCount: 1000,
            maturityRating: "NOT_MATURE",
            allowAnonLogging: true,
            contentVersion: "1.0.0",
            imageLinks: Book.VolumeInfo.ImageLinks(
                smallThumbnail: "http://books.google.com/books/content?id=Ru58xAaPZxcC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
                thumbnail: "http://books.google.com/books/content?id=Ru58xAaPZxcC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
            ),
            language: "en",
            previewLink: "http://books.google.ru/books?id=Ru58xAaPZxcC&printsec=frontcover&dq=subject:fiction&hl=&cd=1&source=gbs_api",
            infoLink: "http://books.google.ru/books?id=Ru58xAaPZxcC&dq=subject:fiction&hl=&source=gbs_api",
            canonicalVolumeLink: "https://books.google.com/books/about/The_Twelve_Chairs.html?hl=&id=Ru58xAaPZxcC"
        ),
        saleInfo: Book.SaleInfo(
            country: "US",
            saleability: "FOR_SALE",
            isEbook: true
        ), accessInfo: Book.AccessInfo(country: "Ru", epub: .init(isAvailable: true, acsTokenLink: "http://books.google.ru/books/download/The_Twelve_Chairs-sample-epub.acsm?id=Ru58xAaPZxcC&format=epub&output=acs4_fulfillment_token&dl_type=sample&source=gbs_api"), webReaderLink: "http://play.google.com/books/reader?id=Ru58xAaPZxcC&hl=&source=gbs_api")
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
           description: "A dystopian novel about totalitarianism.", publishedDate: "1949-06-08",
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
            description: "An epic fantasy adventure.", publishedDate: "1954-07-29",
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
            description: "A romantic novel of manners.", publishedDate: "1813-01-28",
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
            description: "A novel about racial injustice.", publishedDate: "1960-07-11",
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
