//
// File name: SavedBookCell.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 08.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

enum SavedBooksAction {
    case isFavorite(_ isFavorite: Bool)
    case share
    case readLater(_ isPlanned: Bool)
    case updateRating(_ rating: Int)
    case markAsReaded(_ isComplete: Bool)
    case selectedBook(_ isSelected: Bool)
}

struct SavedBookCell: View {
    let book: SavedBooks
    
    var buttonAction: (_ result: SavedBooksAction) -> Void
    
    
    init(book: SavedBooks, buttonAction: @escaping (_ action: SavedBooksAction) -> Void) {
        self.book = book
        self.isCompleted = book.isCompleteReaded
        self.isPlanned = book.isPlannedToRead
        self.buttonAction = buttonAction
        self.isFav = book.isFavorite
    }
    
    @State private var isFav: Bool
    @State private var isCompleted: Bool
    @State private var isPlanned: Bool
    @State private var scale: CGFloat = 1.0
    @State private var backgroundColor: Color = Color.secondary
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 10) {
                AsyncImageView(url: book.coverURL,title: book.title,author: book.authors)
                    .frame(width: geometry.size.width / 3, height: max(100, geometry.size.height - 30))
                infoView
            }
            .padding()
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.secondary, lineWidth: 1)
            }
        }
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .scaleEffect(scale)
        .frame(maxWidth: .infinity,maxHeight: 200)
        .overlay(alignment: .topTrailing) {
            overlayButtons
        }
        .onAppear {
            loadConverAndExtractColor()
        }
    }
    
    private var infoView: some View {
        VStack(alignment: .leading,spacing: 5) {
            InfoCell("", book.title, font: .headline)
            InfoCell("person", book.authors)
            InfoCell("list.bullet", book.category)
            InfoCell("calendar",book.publishedDate)
            InfoCell("calendar.badge.plus",book.createdAt.formattedDate())
            StarRatingView(rating: Binding(
                get: {
                    Int(book.averageRating ?? 0)
            }, set: { newRating in
                buttonAction(.updateRating(newRating))
            }))
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding()
    }
    
    
    private var overlayButtons: some View {
        HStack(spacing: 5) {
            Button {
                isPlanned.toggle()
                buttonAction(.readLater(isPlanned))
            } label: {
                let plannedImage = isPlanned ? "bookmark.fill" : "bookmark"
                createImage(plannedImage,fontSize: 20)
            }

            Button {
                isFav.toggle()
                buttonAction(.isFavorite(isFav))
            } label: {
                let isFav = isFav ? "heart.fill" : "heart"
                createImage(isFav,fontSize: 20)
            }
            
            Button {
                buttonAction(.share)
            } label: {
                createImage("square.and.arrow.up",fontSize: 20,primaryColor: .black,secondaryColor: .blue)
            }
        }
        .padding([.top,.trailing], 10)
    }
    
    private func loadConverAndExtractColor() {
        guard let url = URL(string: book.coverURL) else { return }
        Task {
            do {
                let (data,_) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data),
                   let dominantColor = image.getDominantColor() {
                       await MainActor.run {
                           backgroundColor = Color(dominantColor)
                       }
                   }
            } catch {
                print("Error extracting color from image: \(error)")
            }
        }
    }
}
