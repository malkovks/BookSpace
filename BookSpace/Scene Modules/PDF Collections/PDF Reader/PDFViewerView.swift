//
// File name: PDFViewerView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 16.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import PDFKit

struct PDFViewerView: View {
    let pdf: SavedPDF
    var onBack: () -> Void
    
//    @State private var settings = PDFSettings()
    @State private var isSettingsPresented: Bool = false
    @State private var isEmpty = false
    @State private var pdfView: PDFView?
    
    @StateObject private var viewModel = PDFViewerViewModel()
    
    private var pageView: some View {
        VStack {
            if let link = fileURL() {
                PDFKitPreview(url: link, settings: $viewModel.settings, pdfView: $viewModel.pdfView)
                    .navigationTitle(pdf.title)
                    .ignoresSafeArea(.all)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < -50 {
                                    nextPage()
                                } else if value.translation.width > 50 {
                                    previousPage()
                                }
                            }
                    )
            } else {
                Text("Can not load PDF")
                    .font(.largeTitle)
            }
        }
    }
    
    private var toolView: some View {
        let nextEnable = pdfView?.canGoToPreviousPage == false
        let previousEnable = pdfView?.canGoToNextPage == false
        return VStack {
            navigationView
            Spacer()
            HStack {
                Button {
                    previousPage()
                } label: {
                    createImage("chevron.left")
                }
                .disabled(previousEnable)
                .opacity(previousEnable ? 1 : 0.5)
                Spacer()
                Button {
                    nextPage()
                } label: {
                    createImage("chevron.right")
                }
                .disabled(nextEnable)
                .opacity(nextEnable ? 1 : 0.5)
            }
            .padding()
            .background(.secondary)
            .frame(maxWidth: .infinity,minHeight: 80,maxHeight: 90,alignment: .bottom)
            .padding(.bottom,20)
        }
    }
    
    private var navigationView: some View {
        VStack {
            CustomNavigationBar(title: pdf.title) {
                Button {
                    onBack()
                } label: {
                    createImage("chevron.left")
                }

            } rightButtons: {
                HStack {
                    Button {
                        isSettingsPresented.toggle()
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                    .opacity(isEmpty ? 0 : 1)
                }
            }

        }
    }
    
    var body: some View {
        ZStack {
            pageView
            toolView
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
        .onAppear {
            isEmpty = fileURL() == nil
        }
        
        .sheet(isPresented: $isSettingsPresented) {
            PDFSettingsView(viewModel: viewModel.settings)
        }
    }
    
    private func isTwoPage() -> Bool {
        viewModel.settings.displayMode == .singlePage || viewModel.settings.displayMode == .twoUp
    }
    
    private func previousPage(){
        withAnimation(.easeOut(duration: 0.4)) {
            pdfView?.goToPreviousPage(nil)
        }
        
    }
    
    private func nextPage(){
        withAnimation(.easeOut(duration: 0.4)) {
            pdfView?.goToNextPage(nil)
        }

        
    }
    
    private func fileURL() -> URL? {
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: pdf.bookmarkData, bookmarkDataIsStale: &isStale)
            
            if isStale {
                print("⚠️ Bookmark is not accessible anymore, consider refreshing the data")
            }
            return url
        } catch {
            print("❌ Error recovering file path: \(error.localizedDescription)")
            return nil
        }
    }
}



        
