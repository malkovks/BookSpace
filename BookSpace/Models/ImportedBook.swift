//
// File name: ImportedBook.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 07.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import Foundation

struct ImportedBook: Identifiable {
    var id: UUID = UUID()
    let title: String
    let author: String?
    let content: String
    let coverImage: Data?
    let metadata: [String: Any]?
    
    init(title: String, author: String? = nil, content: String, coverImage: Data? = nil, metadata: [String:Any]? = nil) {
        self.author = author
        self.title = title
        self.content = content
        self.coverImage = coverImage
        self.metadata = metadata
    }
}

enum ImportError: Error {
    case unsupportedFormat
    case notImplemented
    case invalidDocumentStructure
    case parsingError
    case errorUnzip
    case fileDoesNotExist
    case errorDecodingDocx
    case errorDecodingEpub
    case noAccessToFileManager
    case manifestNotFound
    case spineNotFound
    
}
