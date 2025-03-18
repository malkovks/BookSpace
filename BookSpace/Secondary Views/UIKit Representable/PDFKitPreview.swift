//
// File name: PDFKitPreview.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 17.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import PDFKit

struct PDFKitPreview: UIViewRepresentable {
    let url: URL
    @Binding var settings: PDFSettingsViewModel
    @Binding var pdfView: PDFView?

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.displayMode = settings.displayMode
        pdfView.displaysAsBook = settings.displayAsBook
        pdfView.autoScales = settings.autoScales
        
        DispatchQueue.main.async {
            self.pdfView = pdfView
        }
        
        return pdfView
    }
        
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.autoScales = settings.autoScales
        uiView.displayMode = settings.displayMode
        uiView.displaysAsBook = settings.displayAsBook
    }
}
