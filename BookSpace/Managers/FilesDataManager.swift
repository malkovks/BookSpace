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
    
    func saveFile(url: URL){
        guard let localURL = copyPDFToDocumentsDirectory(from: url) else {
            print("❌ Can not copy file to documents directory")
            return
        }
        
        do {
            let bookmarkData = try localURL.bookmarkData(options: .minimalBookmark)
            let pdfData = try Data(contentsOf: localURL)
            
            let file = SavedPDF(title: localURL.lastPathComponent, bookmarkData: bookmarkData, pdfData: pdfData)
            context.insert(file)
            
        } catch {
            print("❌ Cannot create bookmarkData: \(error.localizedDescription)")
        }
        
        
        saveChanges()
    }
    
    func deleteAllPDFFiles() throws {
        let descriptor = FetchDescriptor<SavedPDF>()
        let books = try context.fetch(descriptor)
        books.forEach(context.delete)
        saveChanges()
    }
    
}

private extension FilesDataManager {
    
    func copyPDFToDocumentsDirectory(from sourceURL: URL) -> URL? {
        guard sourceURL.startAccessingSecurityScopedResource() else {
            print("❌ Did not get access to the resource")
            return nil
        }
        
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = directory.appendingPathComponent(sourceURL.lastPathComponent)

        if fileManager.fileExists(atPath: destinationURL.path) {
            print("📁 File almost already exists: \(destinationURL.path)")
            return destinationURL
        }

        do {
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            print("✅ File copied successfully: \(destinationURL.path)")
            return destinationURL
        } catch {
            print("❌ Error copying file: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveChanges(){
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
