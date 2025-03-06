//
// File name: ShareManager.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 06.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

final class ShareManager: ObservableObject {
    @Published var shareItems: [Any] = []
    @Published var isSharePresented: Bool = false
    
    func share(_ book: Book) {
        guard let url = URL(string: book.volumeInfo.canonicalVolumeLink) else { return }
        let title = book.volumeInfo.title
        let authors = book.volumeInfo.authors.joined(separator: ", ")
        let message = "Check out this book \"\(title)\" by \(authors)"
        
        var items : [Any] = [url,message]
        let thumbnailString = book.volumeInfo.imageLinks.thumbnail
        if let imageUrl = URL(string: thumbnailString) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                if let data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.shareItems = [url,message,image]
                        self.isSharePresented = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.shareItems = items
                        self.isSharePresented = true
                    }
                }
            }.resume()
        } else {
            shareItems = items
            isSharePresented = true
        }
    }
}
