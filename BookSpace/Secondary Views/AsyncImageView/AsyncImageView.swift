//
// File name: AsyncImageView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 02.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import Combine

struct AsyncImageView: View {
    let url: String
    let title: String
    let author: String?
    var loadedImage: ((UIImage) -> Void?)? = nil
    
    @StateObject private var viewModel = AsyncImageViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            Group {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.skyBlue)
                    
                } else if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.black)
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Color.gray
                        .frame(width: 150, height: 200)
                }
            }
            .frame(alignment: .center)
            .onAppear {
                viewModel.loadOrGenerate(url: url, title: title, author: author, size: proxy.size)
            }
        }
    }
}
