//
// File name: PDFViewerViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 18.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import PDFKit

@Observable
class PDFViewerViewModel: ObservableObject {
    var settings = PDFSettingsViewModel()
    var isEmpty = false
    var pdfView: PDFView?
    
    
}
