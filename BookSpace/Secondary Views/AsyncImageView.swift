//
// File name: AsyncImageView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 02.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct AsyncImageView: View {
    let url: String
    @State private var image: UIImage? = nil
    @State private var isLoading: Bool = true
    
    var loadedImage: ((UIImage) -> Void?)? = nil
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.black)
                    .scaleEffect(1.5)
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.skyBlue)
                
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.gray)
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage(){
        if let cachedImage = ImageCache.shared.get(forKey: url) {
            self.image = cachedImage
            self.loadedImage?(cachedImage)
            self.isLoading = false
            return
        }
        guard let imageURL = URL(string: url) else {
            self.isLoading = false
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                if let uiimage = UIImage(data: data) {
                    ImageCache.shared.set(uiimage, forKey: url)
                    await MainActor.run {
                        self.loadedImage?(uiimage)
                        self.image = uiimage
                        self.isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}

