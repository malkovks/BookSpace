//
// File name: BookPageView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 08.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct BookPageView: View {
    var importedBook: ImportedBook?
    var error: Error?
    
    var body: some View {
        ZStack(alignment: .center) {
            if let error {
                Text(error.localizedDescription)
                    .font(.largeTitle)
            } else if let importedBook {
                ScrollView {
                    VStack(alignment: .center) {
                        Text(importedBook.title)
                            .font(.headline)
                        Text(importedBook.author ?? "")
                            .font(.subheadline)
                        Text(importedBook.content)
                            .font(.callout)
                    }
                }
                .padding()
            } else {
                Text("Error: No book")
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        
    }
}
