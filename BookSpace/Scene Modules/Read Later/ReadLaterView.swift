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
        NavigationStack(path: $viewModel.navigationPath) {
            listView
                .navigationDestination(for: BookIdentifiable.self) { bookWrapper in
                    if let selectedBook = viewModel.selectedBook {
                        BookDetailView(book: bookWrapper.book, isFavorite: selectedBook.isFavorite, isFutureReading: selectedBook.isPlannedToRead) {
                            viewModel.navigationPath.removeLast()
                        } isAddedToFavorite: { isFavorite in
                            viewModel.updateFavStatus(for: selectedBook, isFavorite: isFavorite)
                        } isAddedToReadLater: { isReadLater in
                            viewModel.updatePlannedStatus(for: selectedBook, isPlanned: isReadLater)
                        }
                    }
                }
        }
    }
    
    private var listView: some View {
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
                            isSelected ? viewModel.addBook(book) : viewModel.removeBook(book)
                        }
                    }
                    .listRowBackground(Color.skyBlue)
                    .onTapGesture {
                        viewModel.selectedBook = book
                        viewModel.navigationPath.append(BookIdentifiable(book: Book(book)))
                    }
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
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .opacity(viewModel.isModelsEmpty ? 0 : 1)
        .onAppear {
            updateRightButtons(AnyView(navigationButtons))
            viewModel.fetchReadLaterBooks()
        }
        .onChange(of: viewModel.isEditing, { oldValue, newValue in
            updateRightButtons(AnyView(navigationButtons))
        })
        .onChange(of: viewModel.selectedItems.isEmpty, { oldValue, newValue in
            updateRightButtons(AnyView(navigationButtons))
        })
        
        .sheet(isPresented: $shareManager.isSharePresented) {
            ShareSheet(items: shareManager.shareItems)
        }
        .alert(isPresented: $viewModel.isStartToDelete) {
            Alert(
                title: Text("Are you sure you want to delete selected items?"),
                primaryButton: .destructive(Text("Delete"), action: {
                    withTransaction(.init(animation: .linear)) {
                        viewModel.deleteSelectedBooks()
                    }
                }),
                secondaryButton: .cancel())
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            if viewModel.isEditing {
                Button {
                    viewModel.isStartToDelete = true
                } label: {
                    createImage("trash",primaryColor: .alertRed)
                }
                .disabled(viewModel.selectedItems.isEmpty)
                .opacity(viewModel.selectedItems.isEmpty ? 0.5 : 1)
                .transition(.opacity.combined(with: .scale))
            }
            Button {
                viewModel.isEditing.toggle()
            } label: {
                Label("Edit", image: "rectangle.and.pencil.and.ellipsis")
            }
            .tint(Color(uiColor: .systemBlue))
            
            
            
        }
        .animation(.bouncy(duration: 0.2, extraBounce: 0.25), value: viewModel.isEditing)
        
    }
}


