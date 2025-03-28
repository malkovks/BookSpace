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
    @EnvironmentObject var viewModel: PDFSettingsViewModel
    @State private var showColorPicker: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                Form {
                    Section {
                        Picker("Select Mode", selection: $viewModel.displayMode) {
                            Text("One page").tag(PDFDisplayMode.singlePage)
                            Text("Continuity").tag(PDFDisplayMode.singlePageContinuous)
                            Text("Two page").tag(PDFDisplayMode.twoUp)
                            Text("Two page(book)").tag(PDFDisplayMode.twoUpContinuous)
                        }
                        .pickerStyle(.inline)
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
                            Button {
                                showColorPicker.toggle()
                            } label: {
                                Label("Background Preview color", systemImage: "paintpalette")
                            }
                            
                            Spacer()
                            Circle()
                                .fill(viewModel.backgroundColor)
                                .frame(height: 20)
                            
                            
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
                            createImage("chevron.down",fontSize: 24)
                        }
                        
                    }
                }
                .navigationDestination(isPresented: $showColorPicker, destination: {
                    CustomColorPickerView(color: $viewModel.backgroundColor)
                })
            }
        }
    }
}

#Preview {
    return PDFSettingsView()
}
