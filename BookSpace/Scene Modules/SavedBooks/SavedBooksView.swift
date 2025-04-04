//
// File name: SavedBooksView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 26.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

struct SavedBooksView: View {
    @StateObject private var viewModel: SavedBooksViewModel
    @StateObject private var shareManager = ShareManager()
    
    var updateRightButtons: (_ buttons: AnyView) -> Void
    var navigateToBookCollection: () -> Void
    
    init(viewModel: SavedBooksViewModel, updateRightButtons: @escaping (_: AnyView) -> Void, navigateToBookCollection: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.updateRightButtons = updateRightButtons
        self.navigateToBookCollection = navigateToBookCollection
    }

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack(alignment: .top) {
                if !viewModel.isModelsEmpty {
                    collectionView
                        .navigationDestination(for: BookIdentifiable.self) { bookWrapper in
                            if let selectedBook = viewModel.selectedBook {
                                BookDetailView(book: bookWrapper.book, isFavorite: true, isFutureReading: selectedBook.isPlannedToRead) {
                                    viewModel.navigationPath.removeLast()
                                } isAddedToFavorite: { isFavorite in
                                    guard !isFavorite else { return }
                                    viewModel.deleteSelectedBook = selectedBook
                                    viewModel.remove()
                                } isAddedToReadLater: { isReadLater in
                                    viewModel.updatePlannedRead(for: selectedBook, needToRead: isReadLater)
                                }
                            }
                        }
                } else {
                    emptyAlertView
                }
            }
            .onAppear {
                viewModel.fetchSavedBooks()
                updateRightButtons(AnyView(
                    navigationView
            ))}
            .sheet(isPresented: $shareManager.isSharePresented) {
                ShareSheet(items: shareManager.shareItems)
            }
            .alert(isPresented: $viewModel.isPresentAlert) {
                alertForDelete
            }
        }
    }
    
    private var alertForDelete: Alert {
        Alert(title: Text("Warning"),
              message: Text("Do you want to delete this book from current list?"),
              primaryButton: .cancel(),
              secondaryButton: .destructive(Text("Delete"), action: {
            withTransaction(.init(animation: .linear(duration: 0.5))) {
                viewModel.remove()
            }
        }))
    }
    
    private var collectionView: some View {
        ScrollView(.vertical){
            LazyVGrid(columns: [GridItem(.flexible())],spacing: 15) {
                ForEach(viewModel.savedBooks,id: \.id) { book in
                    SavedBookCell(book: book) { result in
                        switch result {
                        case .isFavorite:
                            viewModel.isPresentAlert = true
                            viewModel.deleteSelectedBook = book
                        case .share:
                            shareManager.shareSavedBook(book)
                        case .readLater(let isPlanned):
                            viewModel.updatePlannedRead(for: book, needToRead: isPlanned)
                        case .updateRating(let rating):
                            viewModel.updateRating(for: book, rating: rating)
                        case .markAsReaded(_):
                            break
                        case .selectedBook(_):
                            break
                        }
                    }
                    .frame(height: 200)
                    .onTapGesture {
                        viewModel.selectedBook = book
                        viewModel.navigationPath.append(BookIdentifiable(book: Book(book)))
                    }
                }
            }
        }
        .refreshable {
            viewModel.fetchSavedBooks()
        }
        .padding(.top, 90)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .opacity(viewModel.isModelsEmpty ? 0 : 1)
        
    }
    
    private var emptyAlertView: some View {
        VStack(spacing: 20) {
            Text("No saved books yet")
                .foregroundColor(.secondary)
                .italic()
                .font(.largeTitle)
            Button {
                navigateToBookCollection()
            } label: {
                Label("Go to book collections", systemImage: "book.pages")
                    .foregroundStyle(.black)
                    .font(.headline)
            }
            .buttonStyle(.bordered)
        }
        .opacity(viewModel.isModelsEmpty ? 1 : 0)
    }
    
    private var navigationView: some View {
        HStack {
            Button {
                print("heart button")
            } label: {
                createImage("heart")
            }
        }
    }
}







#Preview {
    let book = SavedBooks(from: bookMockModel.first!)
    SavedBookCell(book: book) { result in
    }
}
