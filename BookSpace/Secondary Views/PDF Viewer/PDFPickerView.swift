//
// File name: PDFPickerView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 16.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI
import UniformTypeIdentifiers

struct PDFPickerView: UIViewControllerRepresentable {
    var onPick: (URL) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) { }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: PDFPickerView
        
        init(parent: PDFPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                parent.onPick(url)
            }
        }
    }
}
