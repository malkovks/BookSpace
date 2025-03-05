//
// File name: BookCell.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 05.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

enum BookAction {
    case favorite
    case share
    case bookmark
}

struct BookCell: View {
    let book: Book
    var isFavorite: Bool
    var isPlanned: Bool
    var callMenu: (_ bookAction: BookAction) -> Void
    
    
    private var isFavoriteText: (String,String) {
        if isFavorite {
            return ("Remove from Favorite", "heart.fill")
        } else {
            return ("Add to Favorite", "heart")
        }
    }
    
    private var isPlannedRead: (String,String) {
        if isPlanned {
            return ("Remove from Planned", "bookmark.fill")
        } else {
            return ("Add to Planned", "bookmark")
        }
    }
    
    var body: some View {
        VStack {
            AsyncImageView(url: book.volumeInfo.imageLinks.thumbnail)
                .frame(width: 100, height: 150)
                .clipShape(.rect(cornerRadius: 10))
            
            Text(book.volumeInfo.title)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            Text(book.volumeInfo.authors.joined(separator: ", "))
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .overlay(alignment: .topTrailing) {
            Menu {
                Button {
                    callMenu(.favorite)
                } label: {
                    Label(isFavoriteText.0, systemImage: isFavoriteText.1)
                }

                Button {
                    callMenu(.share)
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                
                Button {
                    callMenu(.bookmark)
                } label: {
                    Label(isPlannedRead.0, systemImage: isPlannedRead.1)
                }
            } label: {
                Image(systemName: "ellipsis")
                    .tint(.black)
                    .font(.system(size: 26, weight: .bold))
                    .frame(width: 30, height: 30)
                    .padding(5)
            }
        }
        .padding()
        .foregroundStyle(.blackText)
        .background(Color.paperYellow)
        .clipShape(.rect(cornerRadius: 10))
        
    }
}
