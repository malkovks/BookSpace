//
// File name: ImportBookView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 07.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import UniformTypeIdentifiers

struct ImportBookView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onError: (Error) -> Void
    var onBook: (_ book: ImportedBook) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let types: [UTType] = [
            .plainText,
            .pdf,
            UTType(filenameExtension: "docx")!,
            UTType(filenameExtension: "epub")!
        ]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: ImportBookView
        
        init(parent: ImportBookView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                parent.onError(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No file selected"]))
                return
            }

            guard url.startAccessingSecurityScopedResource() else {
                parent.onError(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not access file"]))
                return
            }

            DispatchQueue.global(qos: .userInitiated).async {
                defer { url.stopAccessingSecurityScopedResource() }

                    do {
                        let book = try BookImportManager.shared.importBook(from: url)
                        
                        Task { @MainActor in
                            self.parent.isPresented = false
                            self.parent.onBook(book)
                        }
                    } catch {
                        Task { @MainActor in
                            self.parent.onError(error)
                        }
                    }
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.isPresented = false
        }
    }
}
