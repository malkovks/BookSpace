//
// File name: PDFSettingsViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 18.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI
import PDFKit

@Observable
class PDFSettingsViewModel: ObservableObject {
    var displayMode : PDFDisplayMode = .singlePage
    var displayAsBook: Bool = false
    var autoScales: Bool = true
    var orientation: PDFDisplayDirection = .vertical
}
