//
// File name: PDFThubmnailView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 20.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import PDFKit


struct ThumbnailView: UIViewRepresentable {
    weak var pdfView: PDFView?

    func makeUIView(context: Context) -> PDFThumbnailView {
        let thumbnailView = PDFThumbnailView()
        thumbnailView.layoutMode = .vertical
        thumbnailView.thumbnailSize = CGSize(width: 25, height: 25)
        thumbnailView.pdfView = pdfView
        return thumbnailView
    }

    func updateUIView(_ uiView: PDFThumbnailView, context: Context) {}
}


