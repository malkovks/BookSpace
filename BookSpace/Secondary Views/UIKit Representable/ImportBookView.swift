//
// File name: ImportBookView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 07.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import UniformTypeIdentifiers

struct ImportBookView: UIViewControllerRepresentable {
    @Binding var importedBook: ImportedBook?
    @Binding var isPresented: Bool
    var onError: (Error) -> Void
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        var types: [UTType] = [.plainText]
        if let docx = UTType.docx {
            types.append(docx)
        }
        if let epubType = UTType.epub {
            types.append(epubType)
        }
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) { }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: ImportBookView
        
        init(parent: ImportBookView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                parent.onError(NSError(domain: "Error opening link", code: 0, userInfo: nil))
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    _ = url.startAccessingSecurityScopedResource()
                    defer { url.stopAccessingSecurityScopedResource() }
                    let book = try BookImportManager.shared.importBook(from: url)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.parent.importedBook = book
                        self?.parent.isPresented = false
                    }
                } catch {
                    DispatchQueue.main.async { [ weak self] in
                        self?.parent.onError(error)
                    }
                }
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.isPresented = false
        }
    }
    
}
