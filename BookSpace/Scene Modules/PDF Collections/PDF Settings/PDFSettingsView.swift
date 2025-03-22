//
// File name: PDFSettings.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 18.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import PDFKit

struct PDFSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PDFSettingsViewModel
    
    var body: some View {
        NavigationStack {
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
                    Picker("Orientation", selection: $viewModel.orientation) {
                        Text("Horizontal").tag(PDFDisplayDirection.horizontal)
                        Text("Vertical").tag(PDFDisplayDirection.vertical)
                    }
                }
                Section {
                    HStack {
                        Circle()
                            .fill(Color.alertRed)
                        Spacer()
                        Button {
                            print("Open color  picker")
                        } label: {
                            Label("Open Color Picker", systemImage: "paintpalette")
                        }
                        
                    }

                } header: {
                    Text("Color Selection")
                }
                
                
            }
            .navigationTitle("PDF Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        createImage("chevron.down",fontSize: 28)
                    }

                }
            }
        }
    }
}
