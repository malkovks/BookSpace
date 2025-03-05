//
// File name: Book.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 22.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import Foundation

struct Book: Codable {
    let kind, id, etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo
    let accessInfo: AccessInfo
    
    struct SaleInfo: Codable {
        let country, saleability: String
        let isEbook: Bool
    }
    
    struct AccessInfo: Codable {
        let country: String
        let epub: Epub
        let webReaderLink: String
        
        struct Epub: Codable {
            let isAvailable: Bool
            let acsTokenLink: String?
        }
        
        struct PDF: Codable {
            let isAvailable: Bool
            let acsTokenLink: String?
        }
    }
    
    struct VolumeInfo: Codable {
        let title: String
        let subtitle: String?
        let authors: [String]
        let publisher, publishedDate, description: String
        let pageCount: Int
        let printType: String
        let categories: [String]
        let averageRating, ratingsCount: Double?
        let maturityRating: String
        let allowAnonLogging: Bool
        let contentVersion: String
        let imageLinks: ImageLinks
        let language: String
        let previewLink, infoLink: String
        let canonicalVolumeLink: String
        
        struct ImageLinks: Codable {
            let smallThumbnail, thumbnail: String
        }
    }
}

struct BookResponse: Codable {
    let items: [Book]?
}
