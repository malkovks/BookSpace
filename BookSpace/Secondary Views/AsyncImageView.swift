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
    @State private var image: UIImage? = nil
    @State private var isLoading: Bool = true
    @State private var generatedImage: UIImage?
    @State private var cancellable = Set<AnyCancellable>()
    
    var loadedImage: ((UIImage) -> Void?)? = nil
    
    var body: some View {
        GeometryReader { proxy in
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
                    Image(uiImage: generatedImage!)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.skyBlue)
                }
            }
            .onAppear {
                loadImage()
                generateImage(size: proxy.size)
            }
        }
    }
    
    private func generateImage(size: CGSize){
        BookCoverGenerator.shared.generateCover(title: "Random name", author: "Test author", size: size)
            .sink { image in
                loadedImage?(image.asUIImage())
                generatedImage = image.asUIImage()
            }
            .store(in: &cancellable)
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

