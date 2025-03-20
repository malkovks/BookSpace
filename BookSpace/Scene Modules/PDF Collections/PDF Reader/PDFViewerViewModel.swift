//
// File name: PDFViewerViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 18.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import PDFKit


class PDFViewerViewModel: ObservableObject {
    @Published var settings = PDFSettingsViewModel()
    @Published var isEmpty = false
    @Published var pdfView: PDFView?
    @Published var isSettingPresented: Bool = false
    
    
}
