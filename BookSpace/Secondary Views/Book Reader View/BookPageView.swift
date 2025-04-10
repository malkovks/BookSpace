//
// File name: BookPageView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 08.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct BookPageView: View {
    @Environment(\.dismiss) var dismiss
    var importedBook: ImportedBook?
    var error: Error?
    var completionHandler: (_ isSaved: Bool) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                if let error {
                    Text(error.localizedDescription)
                        .font(.largeTitle)
                } else if let importedBook {
                    ScrollView {
                        VStack(alignment: .center) {
                            Text(importedBook.author ?? "")
                                .font(.subheadline)
                            Text(importedBook.content)
                                .font(.callout)
                                .lineSpacing(8)
                                .kerning(0.5)
                                .tracking(1)
                                .multilineTextAlignment(.leading)
                                .truncationMode(.tail)
                                .padding()
                        }
                    }
                    .padding()
                } else {
                    Text("Error: No book")
                }
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .navigationTitle(importedBook?.title ?? "No title")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    completionHandler(false)
                    dismiss()
                } label: {
                    createImage("chevron.down",fontSize: 18,primaryColor: .black)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    completionHandler(true)
                    dismiss()
                } label: {
                    Label("Save to Library", systemImage: "arrow.down.document.fill")
                        .tint(Color(uiColor: UIColor.systemBlue))
                }
            }
        }
    }
}
