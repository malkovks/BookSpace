//
// File name: SavedPDF.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 16.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import SwiftData

@Model
final class SavedPDF {
    @Attribute(.unique) var id: UUID
    var title: String
    var bookmarkData: Data
    var pdfData: Data
    var dateAdded: Date
    var isFavorite: Bool
    var isPlanned: Bool
    var isCompleteReading: Bool
    
    init(title: String, bookmarkData: Data, pdfData: Data, isFavorite: Bool = false, isPlanned: Bool = false, isCompleteReading: Bool = false) {
        self.id = UUID()
        self.title = title
        self.bookmarkData = bookmarkData
        self.pdfData = pdfData
        self.dateAdded = Date()
        self.isFavorite = isFavorite
        self.isPlanned = isPlanned
        self.isCompleteReading = isCompleteReading
    }
}
