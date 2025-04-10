//
// File name: PDFLibraryView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 16.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct PDFLibraryView: View {
    
    @StateObject private var viewModel: PDFLibraryViewModel
    @StateObject private var settingViewModel: PDFSettingsViewModel = .init()
    private let cameraManager = CameraAccessManager.shared
    
    var updateRightButtons: (_ buttons: AnyView) -> Void
    
    init(viewModel: PDFLibraryViewModel, updateRightButtons: @escaping (_: AnyView) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.updateRightButtons = updateRightButtons
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            contentView
        }
        .onAppear {
            viewModel.fetchSavedFiles()
            updateRightButtons(AnyView(navigationButtons))
        }
        
        .fullScreenCover(isPresented: $viewModel.isDeleteFile, content: {
            alertView
        })
        
        .sheet(item: $viewModel.activeSheet, content: { libraryType in
            NavigationView {
                switch libraryType {
                case .import:
                    ImportBookView(isPresented: $viewModel.showImportBook)
                    { result in
                        viewModel.handleConvertDoc(result)
                    }
                case .pageView(book: let book):
                    BookPageView(importedBook: book) { isNeedToSave in
                        print("isNeedToSave: \(isNeedToSave)")
                    }
                case .pdfPicker:
                    PDFPickerView {
                        viewModel.savedPDF(url: $0)
                    }
                }
            }
        })
        .confirmationDialog("What to do",isPresented: $viewModel.isPresentDialog) {
            Button("Import PDF") {
                viewModel.activeSheet = .pdfPicker
            }
            Button("Import other types") {
                viewModel.activeSheet = .import
            }
            
            Button("Scan text") {
                viewModel.handleCameraAndStartScan()
            }
        }
        
        .navigationDestination(for: LibraryRoute.self, destination: {
            switch $0 {
            case .preview:
                PDFPreviewView(text: viewModel.detectedText, context: viewModel.modelContext)
            case .scan:
                ScannerView { result in
                    viewModel.handleScan(result)
                }
            case .viewPDF(let book):
                PDFViewerView(pdf: book.pdf) {
                    viewModel.navigationPath.removeLast()
                }
            }
        })
        
        .alert("Enter the text",isPresented: $viewModel.isChangeName) {
            TextField("Enter the text", text: $viewModel.textFieldName)
            Button("Update") {
                viewModel.updateName()
            }
            Button("Cancel") {
                viewModel.textFieldName = ""
            }
        } message: {
            Text("Please, Enter new name title of book")
        }
    }
}

private extension PDFLibraryView {
    
    var contentView: some View {
        ZStack {
            if viewModel.savedFiles.isEmpty {
                Text("No files found")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
            } else {
                listView
            }
        }
    }
    
    var accessAlertView: some View {
        AlertView(
            isShowingAlert: $viewModel.showAlert,
            model: AlertModel(message: viewModel.alertMessage, confirmActionText: "", cancelActionText: "",hideButton: true , confirmAction: {
                viewModel.showAlert = false
            }, cancelAction: {
                viewModel.showAlert = false
            }))
    }
    
    var alertView: some View {
        AlertView(isShowingAlert: $viewModel.isDeleteFile, model: AlertModel(title: "Warning", message: "Do you want to delete selected item?", confirmActionText: "Delete", cancelActionText: "Cancel", confirmAction: {
            viewModel.deletePDF()
            viewModel.isDeleteFile = false
        }, cancelAction: {
            viewModel.isDeleteFile = false
        }))
    }
    
    var navigationButtons: some View {
        HStack {
            Button {
                viewModel.isPresentDialog = true
            } label: {
                Label("Import", systemImage: "document.badge.plus.fill")
                    .tint(.black)
            }
        }
    }
    
    var listView: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns,spacing: 20) {
                ForEach(viewModel.savedFiles, id: \.id) { file in
                    ListViewCell(file: file, viewModel: viewModel)
                }
            }
        }
        .refreshable {
            viewModel.fetchSavedFiles()
        }
        .padding(.top, 90)
        .padding(.horizontal,10)
    }
}


