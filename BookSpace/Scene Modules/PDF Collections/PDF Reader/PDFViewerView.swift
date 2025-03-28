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
    
    @StateObject private var viewModel = PDFViewerViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            pageView
            if viewModel.isThumbnailPresented {
                thumbnailView
            }
            navigationView
            toolView
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
        .onAppear {
            viewModel.isEmpty = pdf.pdfData.isEmpty
        }
        
        .sheet(isPresented: $viewModel.isSettingPresented) {
            PDFSettingsView()
                .environmentObject(viewModel.settings)
        }
    }
    
    private var thumbnailView: some View {
        HStack {
            Spacer()
            ThumbnailView(pdfView: viewModel.pdfView)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .padding(.top, 100)
                .frame(maxWidth: 50,alignment: .trailing)
        }
    }
    
    private var pageView: some View {
        VStack {
            if let doc = PDFDocument(data: pdf.pdfData) {
                PDFKitPreview(doc: doc, pdfView: $viewModel.pdfView)
                    .environmentObject(viewModel.settings)
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
        .padding(.top, 80)
    }
    
    private var toolView: some View {
        let nextEnable = viewModel.pdfView?.canGoToPreviousPage == false
        let previousEnable = viewModel.pdfView?.canGoToNextPage == false
        return VStack {
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
        .opacity(viewModel.settings.displayAsBook ? 1 : 0)

    }
    
    private var navigationView: some View {
        VStack {
            CustomNavigationBar(title: "") {
                Button {
                    onBack()
                } label: {
                    createImage("chevron.left")
                }
            } rightButtons: {
                HStack {
                    Button {
                        withAnimation {
                            viewModel.isSearchPresented.toggle()
                        }
                    } label: {
                        createImage("text.magnifyingglass")
                    }
                    
                    Button {
                        withAnimation {
                            viewModel.isSettingPresented.toggle()
                        }
                    } label: {
                        createImage("gear")
                    }
                    .opacity(viewModel.isEmpty ? 0 : 1)
                    Button {
                        withAnimation {
                            viewModel.isThumbnailPresented.toggle()
                        }
                    } label: {
                        withAnimation {
                            createImage(
                                viewModel.isThumbnailPresented ?
                                "inset.filled.righthalf.arrow.right.rectangle" :
                                    "inset.filled.trailinghalf.rectangle"
                            )
                        }
                    }
                }
            }
            .padding(.top,60)
            .frame(minHeight: 100, maxHeight: 100)
        }
    }
    
    
    
    private func isTwoPage() -> Bool {
        viewModel.settings.displayMode == .singlePage || viewModel.settings.displayMode == .twoUp
    }
    
    private func previousPage(){
        withAnimation(.easeOut(duration: 0.4)) {
            viewModel.pdfView?.goToPreviousPage(nil)
        }
    }
    
    private func nextPage(){
        withAnimation(.easeOut(duration: 0.4)) {
            viewModel.pdfView?.goToNextPage(nil)
        }
    }
}



        
