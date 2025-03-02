//
// File name: BookDetailView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 02.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct BookDetailView: View {
    let book: Book
    
    @StateObject private var viewModel = BookDetailViewModel()
    
    var body: some View {
        ZStack {
            viewModel.backgroundColor
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    AsyncImageView(url: book.volumeInfo.imageLinks.thumbnail,loadedImage: { image in
                        let image = Image(uiImage: image)
                        viewModel.extractColor(from: image)
                    })
                    .frame(height: 250)
                    .clipShape(.rect(cornerRadius: 10))
                    Text(book.volumeInfo.title)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                    let authors = book.volumeInfo.authors
                    Text(authors.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    if !book.volumeInfo.description.isEmpty {
                        Text(book.volumeInfo.description)
                            .font(.body)
                            .padding()
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}

