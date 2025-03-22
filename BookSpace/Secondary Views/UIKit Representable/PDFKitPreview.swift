//
// File name: PDFKitPreview.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 17.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import PDFKit

struct PDFKitPreview: UIViewRepresentable {
    
    let doc: PDFDocument
    @Binding var settings: PDFSettingsViewModel
    @Binding var pdfView: PDFView?

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        
        pdfView.document = doc
        pdfView.displayMode = settings.displayMode
        pdfView.displaysAsBook = settings.displayAsBook
        pdfView.autoScales = /*settings.autoScales*/false
        pdfView.backgroundColor = UIColor(Color.paperYellow).withAlphaComponent(0.2)
        pdfView.displayDirection = .horizontal
        pdfView.minScaleFactor = 1.0
        pdfView.maxScaleFactor = 2.0
        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.pageBreakMargins = .init(top: 8, left: 16, bottom: 8, right: 16)
        
        pdfView.delegate = context.coordinator
        
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
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, PDFViewDelegate {
        func pdfViewWillChangeScaleFactor(_ sender: PDFView, toScale scale: CGFloat){
            let minScale = sender.scaleFactorForSizeToFit
            DispatchQueue.main.async {
                if sender.scaleFactor < minScale {
                    sender.scaleFactor = minScale
                }
            }
        }
    }
}
