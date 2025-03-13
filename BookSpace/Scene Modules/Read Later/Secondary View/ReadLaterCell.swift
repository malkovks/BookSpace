//
// File name: ReadLaterCell.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 13.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct ReadLaterCell: View {
    let book: SavedBooks
    @Binding var isEditing: Bool
    let buttonActions: (_ actions: SavedBooksAction) -> Void?
    
    init(book: SavedBooks,isEditing: Binding<Bool>, buttonActions: @escaping (_ actions: SavedBooksAction) -> Void?) {
        self.book = book
        self._isEditing = isEditing
        self.buttonActions = buttonActions
        self.isFavorite = book.isFavorite
        self.isPlanned = book.isPlannedToRead
        self.isCompleteRead = book.isCompleteReaded
    }
    @State private var isModelSelected = false
    @State private var isCompleteRead: Bool
    @State private var isPlanned: Bool
    @State private var isFavorite: Bool
    
    var body: some View {
        HStack {
            coverImage
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(book.authors)
                    .font(.subheadline)
                    .lineLimit(2)
                    .frame(alignment: .leading)
            }
            Spacer(minLength: 10)
            if isEditing {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isModelSelected.toggle()
                        buttonActions(.selectedBook(isModelSelected))
                    }
                } label: {
                    CircleView(isSelected: $isModelSelected)
                        .frame(width: 30, height: 30)
                }
                
            } else {
                menuView
                    .transition(.symbolEffect(.disappear))
            }
        }
        .overlay(alignment: .topLeading) {
            if isCompleteRead && !isEditing{
                checkmarkIcon
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            leadingSwipeAction
        }
        
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            trailingSwipeAction
        }
        
        .animation(.easeInOut(duration: 0.5), value: isEditing)
        .onChange(of: isEditing, { _, newValue in
            if newValue {
                isModelSelected = false
            }
        })
    }
    
    private var checkmarkIcon: some View {
        withAnimation(.easeIn(duration: 0.5)) {
            createImage("checkmark.circle.fill",fontSize: 18,primaryColor: .white,secondaryColor: .black)
                .frame(width: 20, height: 20, alignment: .topLeading)
                .transition(.scale.combined(with: .opacity))
        }
    }
    
    private var coverImage: some View {
        AsyncImageView(url: book.coverURL)
            .frame(maxWidth: isEditing ? 0 : 80, maxHeight: isEditing ? 0 : 80,alignment: .leading)
            .isHidden(isEditing)
            .padding([.vertical], 10)
            .padding(.leading,isEditing ? 0 : (isCompleteRead ? 10 : 10))
            .animation(.easeInOut(duration: 0.5), value: isCompleteRead || isEditing)
            .opacity(isEditing ? 0 : 1)
    }
    
    private var leadingSwipeAction: some View {
        Button {
            isCompleteRead.toggle()
            buttonActions(.isFavorite(isCompleteRead))
        } label: {
            Label(isCompleteRead ? "Mark as unread" : "Mark as read", systemImage: isCompleteRead ? "checkmark.circle.fill" : "checkmark.circle")
        }
        .tint(isCompleteRead ? .gray : .green)
    }
    
    private var trailingSwipeAction: some View {
        Button {
            isPlanned.toggle()
            buttonActions(.readLater(isPlanned))
        } label: {
            Label(isPlanned ? "Remove from read later" : "Add to read later", systemImage: isPlanned ? "bookmark.fill" : "bookmark")
        }
        .tint(isPlanned ? .alertRed : .paperYellow)
    }
    
    private var menuView: some View {
        Menu {
            Section("Update status") {
                Button {
                    isFavorite.toggle()
                    buttonActions(.isFavorite(isFavorite))
                } label: {
                    Label(isFavorite ? "Remove from favorites" : "Add to favorites", systemImage: isFavorite ? "star.fill" : "star")
                }
                
                Button {
                    isPlanned.toggle()
                    buttonActions(.readLater(isPlanned))
                } label: {
                    Label(isPlanned ? "Remove from read later" : "Add to read later", systemImage: isPlanned ? "bookmark.fill" : "bookmark")
                }
                
                Button {
                    isCompleteRead.toggle()
                    buttonActions(.markAsReaded(isCompleteRead))
                } label: {
                    Label(isCompleteRead ? "Mark as unread" : "Mark as read", systemImage: isCompleteRead ? "checkmark.circle.fill" : "checkmark.circle")
                }
            }
            Section {
                Button {
                    buttonActions(.share)
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .tint(.black)
                .font(.system(size: 18, weight: .regular))
                .frame(width: 30, height: 30)
                .padding(5)
        }
    }
}

#Preview {
    ReadLaterCell(book: SavedBooks(from: bookMockModel.first!), isEditing: .constant(false)) { actions in
        switch actions {
        case .isFavorite(let favorite):
            break
        case .share:
            break
        case .readLater(_):
            break
        case .updateRating(_):
            break
        case .markAsReaded(_):
            break
        case .selectedBook(_):
            break
        }
    }
        
        .background(Color.skyBlue)
}
