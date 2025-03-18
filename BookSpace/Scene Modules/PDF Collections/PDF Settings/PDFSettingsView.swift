//
// File name: PDFSettings.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 18.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import PDFKit

struct PDFSettingsView: View {
    @ObservedObject var viewModel: PDFSettingsViewModel
    
    var body: some View {
        Form {
            Section {
                Picker("Mode", selection: $viewModel.displayMode) {
                    Text("One page").tag(PDFDisplayMode.singlePage)
                    Text("Continuity").tag(PDFDisplayMode.singlePageContinuous)
                    Text("Two page").tag(PDFDisplayMode.twoUp)
                    Text("Two page(book)").tag(PDFDisplayMode.twoUpContinuous)
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Display Mode")
            }
            
            Section {
                Toggle("Book mode on", isOn: $viewModel.displayAsBook)
                Toggle("Page scaling", isOn: $viewModel.autoScales)
            }
        }
        .navigationTitle("PDF Settings")
    }
}
