//
// File name: ReadLaterView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 03.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct ReadLaterView: View {
    @StateObject private var viewModel: ReadLaterViewModel
    @StateObject private var shareManager = ShareManager()
    
    
    var updateRightButtons: (_ buttons: AnyView) -> Void
    var navigateToBookCollection: () -> Void
    
    init(viewModel: ReadLaterViewModel, updateRightButtons: @escaping (_: AnyView) -> Void, navigateToBookCollection: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.updateRightButtons = updateRightButtons
        self.navigateToBookCollection = navigateToBookCollection
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                List {
                    ForEach(viewModel.books, id: \.id) { book in
                        Section {
                            ReadLaterCell(book: book, isEditing: $viewModel.isEditing) { actions in
                                switch actions {
                                case .isFavorite(let isFavorite):
                                    viewModel.updateFavStatus(for: book, isFavorite: isFavorite)
                                case .share:
                                    shareManager.share(Book.init(book))
                                case .readLater(let isReadLater):
                                    viewModel.updatePlannedStatus(for: book, isPlanned: isReadLater)
                                case .updateRating:
                                    break
                                case .markAsReaded(let complete):
                                    viewModel.updateCompleteStatus(for: book, isComplete: complete)
                                case .selectedBook(let isSelected):
                                    if isSelected {
                                        viewModel.selectedItems.insert(book)
                                    } else {
                                        viewModel.selectedItems.remove(book)
                                    }
                                }
                            }
                            .listRowBackground(Color.skyBlue)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .listRowSeparator(.hidden)
                .listStyle(.insetGrouped)
                .refreshable {
                    viewModel.fetchReadLaterBooks()
                }
                .padding(.top, 90)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .opacity(viewModel.isModelsEmpty ? 0 : 1)
            }
            .onAppear {
                updateRightButtons(AnyView(navigationButtons))
                viewModel.fetchReadLaterBooks()
                //must be buttons for navigation
            }
            .sheet(isPresented: $shareManager.isSharePresented) {
                ShareSheet(items: shareManager.shareItems)
            }
            .alert(isPresented: $viewModel.isStartToDelete) {
                Alert(
                    title: Text("Are you sure you want to delete selected items?"),
                    primaryButton: .destructive(Text("Delete"), action: {
                        viewModel.deleteSelectedBooks()
                    }),
                    secondaryButton: .cancel())
            }
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            Button {
                viewModel.isEditing.toggle()
            } label: {
                Label("Edit", image: "rectangle.and.pencil.and.ellipsis")
            }
            
            if viewModel.isEditing && !viewModel.selectedItems.isEmpty {
                Button {
                    viewModel.isStartToDelete.toggle()
                } label: {
                    createImage("trash",primaryColor: .red)
                }
            }
        }
    }
}


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
            AsyncImageView(url: book.coverURL)
                .frame(maxWidth: 80, maxHeight: 80,alignment: .leading)
                .padding([.vertical], 10)
                .padding(.leading,isCompleteRead ? 40 : 10)
                .animation(.easeIn(duration: 0.5), value: isCompleteRead)
                .opacity(isEditing ? 0 : 1)
                .animation(.easeInOut(duration: 0.5), value: isEditing)
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
                    createImage("circle")
                }

            } else {
                menuView
                    .transition(.move(edge: .trailing))
            }
        }
        .overlay(alignment: .topLeading) {
            if isCompleteRead && !isEditing{
                withAnimation(.easeIn(duration: 0.5)) {
                    createImage("checkmark.circle.fill",fontSize: 18,primaryColor: .white,secondaryColor: .black)
                        .padding([.top,.leading], 5)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                isCompleteRead.toggle()
                buttonActions(.markAsReaded(isCompleteRead))
            } label: {
                Label(isCompleteRead ? "Mark as unread" : "Mark as read", systemImage: isCompleteRead ? "checkmark.circle.fill" : "checkmark.circle")
            }
            .tint(isCompleteRead ?  .gray : .green)
        }
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
