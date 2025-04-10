//
// File name: PDFLibraryViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 16.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import SwiftData

internal enum LibraryRoute: Hashable {
    case viewPDF(BookPDFIdentifiable)
    case scan
    case preview
}

internal enum LibraryViewSheets: Identifiable {
    case `import`
    case pageView(book: ImportedBook)
    case pdfPicker
    
    
    var id: String {
        switch self {
        case .import: return "importBook"
        case .pageView: return "bookTextView"
        case .pdfPicker: return "pdfPicker"
        }
    }
}

internal enum LibraryViewModelError: Error {
    case errorImport
    case failureScan
}

@MainActor
class PDFLibraryViewModel: ObservableObject {
    
    //Managers
    private let fileDataManager: FilesDataManager
    private let cameraAccess: CameraAccessManager
    @Published var modelContext: ModelContext
    @Published var navigationPath: [LibraryRoute] = []
    @Published var activeSheet: LibraryViewSheets?
    
    //Properties
    @Published var savedFiles: [SavedPDF] = []
    @Published var selectedPDF: SavedPDF?
    @Published var selectedFile: SavedPDF?
    @Published var selectedBook: ImportedBook?
    
    //String values
    @Published var textFieldName: String = ""
    @Published var alertMessage: String = "Unknown error"
    @Published var detectedText: String = ""
    
    //Flags
    @Published var isDeleteFile: Bool = false
    @Published var showAlert: Bool = false
    @Published var isChangeName: Bool = false
    @Published var showingPicker: Bool = false
    @Published var showCameraView: Bool = false
    @Published var showImportBook: Bool = false
    @Published var showTextView : Bool = false
    @Published var isPresentDialog: Bool = false
    
    
    
    
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.fileDataManager = FilesDataManager(context: modelContext)
        self.cameraAccess = CameraAccessManager.shared
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
    
    func handleCameraAndStartScan() {
        Task {
            await cameraAccess.requestAccess { result in
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success:
                        self?.navigationPath.append(.scan)
                        self?.showCameraView = true
                    case .failure(let failure):
                        self?.handleCameraError(failure)
                    }
                }
            }
        }
    }
    
    func handleScan(_ result: Result<String,Error>) {
        switch result {
        case .success(let text):
            detectedText = text
            navigationPath.append(.scan)
        case .failure:
            handleOtherError(.failureScan)
        }
    }
    
    @MainActor
    func handleOtherError(_ error: LibraryViewModelError){
        switch error {
        case .errorImport:
            alertMessage = "Failed to import selected file. Try again"
        case .failureScan:
            alertMessage = "Failed to scan selected text. Try again"
        }
        showAlert = true
    }
    
    func handleConvertDoc(_ result: Result<ImportedBook,Error>){
        switch result {
        case .success(let book):
            showImportBook = false
            selectedBook = book
            showTextView = true
        case .failure:
            handleOtherError(.errorImport)
        }
    }
    
    @MainActor
    func handleCameraError(_ error: CameraAccess){
        switch error {
        case .denied:
            alertMessage = "Camera access is denied"
        case .restricted:
            alertMessage = "Camera access is restricted"
        case .notDetermined:
            alertMessage = "Camera access not determined"
        case .unknown:
            alertMessage = "Unknown error"
        case .noAccessToVisionKit:
            alertMessage = "No access to VisionKit. This function is not available on your device"
        }
        
        showAlert = true
    }
}
