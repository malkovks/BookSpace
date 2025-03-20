//
// File name: FilesDataManager.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 16.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftData
import Foundation

@MainActor
class FilesDataManager {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func updateName(of file: SavedPDF, to newName: String){
        file.title = newName
        saveChanges()
    }
    
    func fetchFiles() -> [SavedPDF] {
        let fetchDescriptor = FetchDescriptor<SavedPDF>(sortBy: [SortDescriptor(\.dateAdded, order: .reverse)])
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching files: \(error)")
            return []
        }
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
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
