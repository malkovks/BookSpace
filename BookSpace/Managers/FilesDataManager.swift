//
// File name: FilesDataManager.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 16.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftData
import Foundation

class FilesDataManager {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchFiles() -> [SavedPDF] {
        let fetchDescriptor = FetchDescriptor<SavedPDF>(sortBy: [SortDescriptor(\.dateAdded, order: .reverse)])
        return (try? context.fetch(fetchDescriptor)) ?? []
    }
    
    func deleteFile(file: SavedPDF){
        context.delete(file)
        saveChanges()
    }
    
    func saveFile(file: SavedPDF){
        context.insert(file)
        saveChanges()
    }
    
    private func saveChanges(){
        try? context.save()
    }
}
