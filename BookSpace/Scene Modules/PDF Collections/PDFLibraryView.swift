//
// File name: PDFLibraryView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 16.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct PDFLibraryView: View {
    @StateObject private var viewModel: PDFLibraryViewModel
    
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
                            PDFViewerView(pdf: $0.pdf)
                        }
                }
            }
        }
        .onAppear {
            viewModel.fetchSavedFiles()
            updateRightButtons(AnyView(navigationButtons))
        }
        .sheet(isPresented: $viewModel.showingPicker) {
            PDFPickerView {
                viewModel.savedPDF(url: $0)
            }
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
        }
    }
    
    private var listView: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns,spacing: 20) {
                ForEach(viewModel.savedFiles, id: \.id) { file in
                    VStack {
                        createImage("document",primaryColor: .updateBlue,secondaryColor: .alertRed)
                        Text(file.title)
                        Text(file.dateAdded.formattedDate())
                            .font(.system(size: 12, weight: .light, design: .monospaced))
                    }
                    .padding()
                    .frame(maxWidth: .infinity,minHeight: 200, maxHeight: 240,alignment: .center)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.6), lineWidth: 2)
                    }
                    .onTapGesture {
                        viewModel.selectedFile = file
                        viewModel.navigationPath.append(BookPDFIdentifiable(pdf: file))
                    }
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
