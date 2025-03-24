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
        fileDataManager.saveFile(url: url)
        fetchSavedFiles()
    }

    
    

}
