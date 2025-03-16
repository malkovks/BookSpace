//
// File name: PDFViewerView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 16.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import PDFKit

struct PDFViewerView: View {
    let pdf: SavedPDF
    
    var body: some View {
        if let link = fileURL() {
            PDFKitPreview(url: link)
                .navigationTitle(pdf.title)
                .ignoresSafeArea(.all)
        } else {
            Text("Can not load PDF")
        }
    }
    
    private func fileURL() -> URL? {
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: pdf.bookmarkData, bookmarkDataIsStale: &isStale)

            if isStale {
                print("⚠️ Bookmark is not accessible anymore, consider refreshing the data")
            }
            return url
        } catch {
            print("❌ Error recovering file path: \(error.localizedDescription)")
            return nil
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

struct PDFKitPreview: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        if let doc = PDFDocument(url: url) {
            pdfView.document = doc
        } else {
            print("Failed to initialize PDFDocument")
            
        }
        
        pdfView.autoScales = true
        return pdfView
    }
        
    func updateUIView(_ uiView: PDFView, context: Context) {}
    
    
}

        
