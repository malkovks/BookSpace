//
// File name: PDFLibraryViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 16.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import SwiftData

@MainActor
class PDFLibraryViewModel: ObservableObject {
    
    
    private let fileDataManager: FilesDataManager
    @Published var savedFiles: [SavedPDF] = []
    @Published var showingPicker: Bool = false
    @Published var selectedFile: SavedPDF?
    @Published var navigationPath = NavigationPath()
    @Published var isChangeName: Bool = false
    @Published var textFieldName: String = ""
    @Published var selectedPDF: SavedPDF?
    @Published var isDeleteFile: Bool = false
    
    init(modelContext: ModelContext) {
        self.fileDataManager = FilesDataManager(context: modelContext)
    }
    
    func fetchSavedFiles(){
        savedFiles = fileDataManager.fetchFiles()
    }
    
    func updateName(){
        guard let selectedPDF, textFieldName != selectedPDF.title else { return }
        fileDataManager.updateName(of: selectedPDF, to: textFieldName)
    }
    
    func deletePDF(){
        guard let selectedPDF else { return }
        fileDataManager.deleteFile(file: selectedPDF)
    }
    
    func deletePDF(at index: IndexSet){
        for i in index {
            fileDataManager.deleteFile(file: savedFiles[i])
        }
        fetchSavedFiles()
    }
    
    func savedPDF(url: URL) {
        guard let localURL = copyPDFToDocumentsDirectory(from: url) else {
            print("❌ Can not copy file to documents directory")
            return
        }

        do {
            let bookmarkData = try localURL.bookmarkData(options: .minimalBookmark)
            let file = SavedPDF(title: localURL.lastPathComponent, bookmarkData: bookmarkData)
            fileDataManager.saveFile(file: file)
            fetchSavedFiles()
        } catch {
            print("❌ Cannot create bookmarkData: \(error.localizedDescription)")
        }
    }

    
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

}
