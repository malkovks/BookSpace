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
            ZStack {
                if viewModel.savedFiles.isEmpty {
                    Text("No files found")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                } else {
                    listView
                        .navigationDestination(for: BookPDFIdentifiable.self) {
                            PDFViewerView(pdf: $0.pdf) {
                                viewModel.navigationPath.removeLast()
                            }
                        }
                }
            }
        }
        .onAppear {
            viewModel.fetchSavedFiles()
            updateRightButtons(AnyView(navigationButtons))
        }
//        .fullScreenCover(isPresented: $viewModel.showCameraView, content: {
//            
//            
//            
//            .ignoresSafeArea()
//            .padding(.top,90)
//            .navigationBarBackButtonHidden(true)
//        })
        
        .fullScreenCover(isPresented: $viewModel.isDeleteFile, content: {
            alertView
        })
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
        
        .sheet(isPresented: $viewModel.showingPicker) {
            PDFPickerView {
                viewModel.savedPDF(url: $0)
            }
        }
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
        
        .navigationDestination(for: String.self) { destination in
            if destination == "preview" {
                PDFPreviewView(text: viewModel.detectedText, context: viewModel.modelContext)
            } else if destination == "scan"{
                
                ScannerView { result in
                    handleScan(result)
                }
            }
        }
    }
    
    private var accessAlertView: some View {
        AlertView(
            isShowingAlert: $viewModel.showAlert,
            model: AlertModel(message: viewModel.alertMessage, confirmActionText: "", cancelActionText: "",hideButton: true , confirmAction: {
                viewModel.showAlert = false
            }, cancelAction: {
                viewModel.showAlert = false
            }))
    }
    
    private var alertView: some View {
        AlertView(isShowingAlert: $viewModel.isDeleteFile, model: AlertModel(title: "Warning", message: "Do you want to delete selected item?", confirmActionText: "Delete", cancelActionText: "Cancel", confirmAction: {
            viewModel.deletePDF()
            viewModel.isDeleteFile = false
        }, cancelAction: {
            viewModel.isDeleteFile = false
        }))
    }
    
    private func handleScan(_ result: Result<String,Error>) {
        switch result {
        case .success(let text):
            viewModel.detectedText = text
            viewModel.navigationPath.append("preview")
        case .failure(let failure):
            print("Scanning failed: \(failure.localizedDescription)")
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            Button {
                withAnimation {
                    viewModel.showingPicker = true
                }
            } label: {
                Label("Add new file", systemImage: "plus")
                    .tint(.black)
            }
            Button {
                Task {
                    await cameraManager.requestAccess(completion: { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success :
                                viewModel.navigationPath.append("scan")
                                viewModel.showCameraView = true
                            case .failure(let failure):
                                handleCameraError(failure)
                            }
                        }
                    })
                }
            } label: {
                createImage("camera.viewfinder",primaryColor: .alertRed,secondaryColor: .black)
            }
        }
    }
    
    private var listView: some View {
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
    
    @MainActor
    private func handleCameraError(_ error: CameraAccess){
        switch error {
        case .denied:
            viewModel.alertMessage = "Camera access is denied"
        case .restricted:
            viewModel.alertMessage = "Camera access is restricted"
        case .notDetermined:
            viewModel.alertMessage = "Camera access not determined"
        case .unknown:
            viewModel.alertMessage = "Unknown error"
        }
        
        viewModel.showAlert = true
    }
}


