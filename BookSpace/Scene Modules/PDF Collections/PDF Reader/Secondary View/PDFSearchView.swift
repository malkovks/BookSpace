//
// File name: PDFSearchView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 01.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.
import SwiftUI
import PDFKit

struct PDFSearchView: View {
    @Binding var pdfView: PDFView?
    var onClose: () -> Void = {}
    @State private var searchText: String = ""
    @State private var searchResult: [PDFSelection] = []
    @State private var currentIndex: Int = 0
    @State private var showSearchBar: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var isTextFieldFocused: Bool
    @State private var debounce: DispatchWorkItem? = nil
    
    init(pdfView: Binding<PDFView?>, onClose: @escaping () -> Void = {} ) {
        self._pdfView = pdfView
        self.onClose = onClose
        setupNotificationCenter()
    }
    private func setupNotificationCenter(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation {
                    self.keyboardHeight = keyboardFrame.height
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            withAnimation {
                self.keyboardHeight = 0
            }
        }
    }
    
    private func removeKeyboardListeners() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    var body: some View {
        ZStack {
            blueBackground
            VStack {
                searchBar
                Spacer()
                buttonBar
            }
        }
        .onChange(of: searchText) { _, newValue in
            debounce?.cancel()
            
            let workItem = DispatchWorkItem { performSearch() }
            debounce = workItem
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        }
        .onAppear {
            setupNotificationCenter()
        }
        
        .onDisappear {
            removeKeyboardListeners()
        }
    }
    
    private var blueBackground: some View {
        VStack {
            Color.skyBlue
                .ignoresSafeArea()
                .frame(height: 100)
                .border(width: 1, edges: [.bottom])
            Spacer()
        }
    }
    
    private var buttonBar: some View {
        VStack {
            HStack(alignment: .center, spacing: 10) {
                if !searchResult.isEmpty {
                    HStack(spacing: 5) {
                        Text("\(currentIndex + 1)/\(searchResult.count)")
                            .font(.system(size: 20))
                        
                        Spacer()
                        
                        Button(action: previousResult) {
                            Image(systemName: "chevron.up")
                        }
                        .foregroundStyle(currentIndex == 0 ? .gray : .black)
                        
                        Button(action: nextResult) {
                            Image(systemName: "chevron.down")
                        }
                        .foregroundStyle(currentIndex == (searchResult.count - 1) ? .gray : .black)
                        
                    }
                    .padding(15)
                    .background(Color.skyBlue)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .safeAreaPadding([.bottom,.horizontal], 10)
        }
        
        .padding(.bottom, keyboardHeight)
        .animation(.easeInOut(duration: 0.2), value: keyboardHeight)
        .border(width: 1, edges: [.top])
    }
    
    private var searchBar: some View {
        VStack {
            HStack {
                TextField("Поиск в PDF", text: $searchText, onCommit: performSearch)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.default)
                    .submitLabel(.search)
                    .focused($isTextFieldFocused)
                
                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark")
                }

            }
        }
        .padding()
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .frame(minHeight: 99,maxHeight: 100)
        .shadow(radius: 5)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
    }
    
    private func performSearch(){
        guard !searchText.isEmpty else {
            clearSearch()
            return
        }
        
        clearSearch()
        
        if let document = pdfView?.document {
            let searchResult = document.findString(searchText, withOptions: .caseInsensitive)
            self.searchResult = searchResult
            if !searchResult.isEmpty {
                currentIndex = 0
                highlightResult(at: 0)
            } else {
                print("Nothing founded")
            }
        }
    }
    
    private func highlightResult(at index: Int) {
        guard index >= 0 && index < searchResult.count else { return }
        pdfView?.highlightedSelections = nil
        
        let selection = searchResult[index]
        selection.color = .paperYellow
        
        pdfView?.highlightedSelections = [selection]
        
        if let page = selection.pages.first {
            pdfView?.go(to: PDFDestination(page: page, at: selection.bounds(for: page).origin))
        }
    }
    
    private func nextResult(){
        guard !searchResult.isEmpty else { return }
        currentIndex = (currentIndex + 1) % searchResult.count
        highlightResult(at: currentIndex)
    }
    
    private func previousResult(){
        guard !searchResult.isEmpty else { return }
        currentIndex = (currentIndex - 1) % searchResult.count
        highlightResult(at: currentIndex)
    }
    
    private func clearSearch(){
        pdfView?.highlightedSelections = nil
        searchResult.removeAll()
    }
}

#Preview {
    PDFSearchView(pdfView: .constant(nil))
}
