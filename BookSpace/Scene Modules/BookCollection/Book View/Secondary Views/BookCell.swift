//
// File name: BookCell.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 05.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

enum BookAction {
    case favorite(_ isFav: Bool)
    case share
    case bookmark(_ isPlanned: Bool)
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
        ZStack(alignment: .top) {
            VStack {
                AsyncImageView(url: book.volumeInfo.imageLinks.thumbnail)
                    .frame(width: 100, height: 150)
                    .clipShape(.rect(cornerRadius: 10))
                Spacer(minLength: 5)
                Text(book.volumeInfo.title)
                    .font(.headline)
                    .fontDesign(.rounded)
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 5)
                Text(book.volumeInfo.authors?.joined(separator: ", ") ?? "")
                    .font(.subheadline)
                    .fontDesign(.monospaced)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 5)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .foregroundStyle(.blackText)
            .background(Color.paperYellow)
            .clipShape(.rect(cornerRadius: 10))
            
            VStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    menuButton
                        .rotationEffect(.degrees(-90))
                        .padding([.top,.trailing], 5)
                        .frame(width: 30, height: 30, alignment: .topTrailing)
                }
            }
        }
        
    }
    
    private var menuButton: some View {
        Menu {
            Button {
                callMenu(.favorite(isFavorite))
            } label: {
                Label(isFavoriteText.0, systemImage: isFavoriteText.1)
            }
            
            Button {
                callMenu(.share)
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Button {
                callMenu(.bookmark(isPlanned))
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
}
