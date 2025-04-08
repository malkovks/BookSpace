//
// File name: AsyncImageViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 07.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import Combine

@Observable
class AsyncImageViewModel : ObservableObject {
    var image: UIImage? = nil
    var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadOrGenerate(url: String, title: String, author: String?, size: CGSize) {
        isLoading = true
        
        loadImage(from: url)
            .catch { _ in
                BookCoverGenerator.shared.generateCover(title: title, author: author, size: size)
                    .map { $0 }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiImage in
                self?.image = uiImage
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func loadImage(from urlString: String) -> AnyPublisher<UIImage,Error> {
        if let cached = ImageCache.shared.get(forKey: urlString) {
            return Just(cached)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data,response in
                guard let uiImage = UIImage(data: data) else {
                    throw URLError(.cannotDecodeRawData)
                }
                ImageCache.shared.set(uiImage, forKey: urlString)
                return uiImage
            }
            .eraseToAnyPublisher()
    }
}
