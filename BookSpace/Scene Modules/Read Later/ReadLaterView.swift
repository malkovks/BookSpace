//
// File name: ReadLaterView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 03.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct ReadLaterView: View {
    @StateObject private var viewModel: ReadLaterViewModel
    
    
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
                ScrollView(.vertical){
                    LazyVGrid(columns: [GridItem(.flexible())],spacing: 15) {
                        ForEach(viewModel.books,id: \.id) { book in
                            SavedBookCell(book: book) { result in
//                                switch result {
//                                case .remove:
//                                    viewModel.isPresentAlert = true
//                                    viewModel.deleteSelectedBook = book
//                                case .share:
////                                    shareManager.shareSavedBook(book)
//                                case .readLater(let isPlanned):
//                                    viewModel.updatePlannedRead(for: book, needToRead: isPlanned)
//                                case .updateRating(let rating):
//                                    viewModel.updateRating(for: book, rating: rating)
//                                case .markAsReaded(let isComplete):
//                                    viewModel.updateCompleteReading(for: book, isComplete)
//                                }
                            }
                            .frame(height: 200)
//                            .onTapGesture {
//                                viewModel.selectedBook = book
//                                viewModel.navigationPath.append(BookIdentifiable(book: Book(book)))
//                            }
                            
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listStyle(.inset)
                .refreshable {
                    viewModel.fetchReadLaterBooks()
                }
                .padding(.top, 90)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .opacity(viewModel.isModelsEmpty ? 0 : 1)
            }
            .onAppear {
                viewModel.fetchReadLaterBooks()
                //must be buttons for navigation
            }
        }
    }
}
