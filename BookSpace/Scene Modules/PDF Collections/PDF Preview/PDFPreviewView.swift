//
// File name: PDFPreviewView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 24.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import PDFKit
import SwiftData

struct PDFPreviewView: View {
    @StateObject var settings: PDFSettingsViewModel = .init()
    let text: String
    
    
    private let fileDataManager: FilesDataManager
    @State private var isLoading: Bool = true
    @State private var pdfURL: URL?
    @State private var pdfData: Data?
    @State private var pdfView: PDFView?
    @State private var titlePDF: String = "Captured file"
    
    
    init(text: String, context: ModelContext){
        self.text = text
        self.fileDataManager = FilesDataManager(context: context)
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Creating file")
            } else if let pdfURL, let pdfData {
                let document = PDFDocument(data: pdfData) ?? PDFDocument()
                PDFKitPreview(doc: document, pdfView: $pdfView)
                    .environmentObject(settings)
            } else {
                Text("Can not create PDF")
            }
        }
        .onAppear {
            generatePDF()
        }
    }
    
    private func generatePDF(){
        DispatchQueue.global(qos: .userInitiated).async {
            let pdfFile = createFilePDF(from: text)
            DispatchQueue.main.async {
                self.fileDataManager.saveFile(url: pdfFile.0)
                self.pdfURL = pdfFile.0
                self.pdfData = pdfFile.1
                self.isLoading = false
            }
        }
    }
    
    private func createFilePDF(from text: String) -> (URL, Data) {
        let pdfMetaData = [
            kCGPDFContextCreator: "BookSpace",
            kCGPDFContextAuthor: "Malkov Konstantin",
            kCGPDFContextTitle: titlePDF
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String : Any]
        
        let pageWidth = 612
        let pageHeight = 792
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        
        let pdfData = renderer.pdfData { context in
            context.beginPage()
            let textRect = CGRect(x: 20, y: 20, width: pageWidth - 40, height: pageHeight - 40)
            text.draw(in: textRect,withAttributes: [.font : UIFont.systemFont(ofSize: 14)])
        }
        let convertedName = titlePDF.replacingOccurrences(of: " ", with: "_")
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("created\(convertedName).pdf")
        try? pdfData.write(to: url)
        return (url,pdfData)
    }
}

