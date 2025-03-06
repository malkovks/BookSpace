//
// File name: ContentView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 22.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI
import SwiftData

struct BookCollectionView: View {
    @StateObject private var viewModel: BookCollectionViewModel
    @State private var isSearchOpened: Bool = false {
        didSet {
            withAnimation(.interpolatingSpring) {
                needToHideNavigation(isSearchOpened)
            }
        }
    }
    
    var updateRightButtons: (_ buttons: AnyView) -> Void
    var needToHideNavigation: (_ isHidden: Bool) -> Void
    @State private var isSharing: Bool = false
    @StateObject private var shareManager = ShareManager()
    
    init(viewModel: BookCollectionViewModel, updateRightButtons: @escaping (_: AnyView) -> Void, needToHideNavigation: @escaping (_: Bool) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.updateRightButtons = updateRightButtons
        self.needToHideNavigation = needToHideNavigation
    }

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    collectionView(geometry)
                        .navigationDestination(for: BookIdentifiable.self) { bookWrapper in
                            BookDetailView(book: bookWrapper.book, isFavorite: viewModel.isFavorite(book: bookWrapper.book), isFutureReading: viewModel.isPlanned(book: bookWrapper.book)) {
                                viewModel.navigationPath.removeLast()
                            } isAddedToFavorite: { isFavorite in
                                isFavorite ? viewModel.addToFavorites(book: bookWrapper.book) : viewModel.removeFromFavorite(book: bookWrapper.book)
                            } isAddedToReadLater: { isReadLater in
                                isReadLater ? viewModel.addToPlanned(book: bookWrapper.book) : viewModel.removeFromPlanning(book: bookWrapper.book)
                            }
                        }
                    
                    if viewModel.isFilterOpened {
                        filterView(geometry)
                    }
                }
                .overlay {
                    if isSearchOpened {
                        searchFieldView
                    }
                    
                    if viewModel.isLoading {
                        progressView
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        errorMessageView(errorMessage)
                    }
                }
                .task {
                    await viewModel.fetchBooks()
                }
                
                .onAppear {
                    updateRightButtons(
                        AnyView(navigationButtons)
                    )
                }
                .sheet(isPresented: $shareManager.isSharePresented) {
                    ShareSheet(items: shareManager.shareItems)
                }
            }
        }
    }
    
    private func filterView(_ geometry: GeometryProxy) -> some View {
        FilterBooksView(filter: $viewModel.selectedFilter) {
            viewModel.isFilterOpened.toggle()
        }
        .frame(width: geometry.size.width / 2, height: geometry.size.height/3)
        .position(x: geometry.size.width - geometry.size.width / 3, y: geometry.size.height/3)
        .transition(.move(edge: .trailing))
    }
    
    private func errorMessageView(_ message: String) -> some View {
        return Text(message)
            .foregroundColor(.red)
            .padding()
    }
    
    private func contextMenuItems(_ book: Book) -> some View {
        let isFav = viewModel.isFavorite(book: book)
        let isPlanned = viewModel.isPlanned(book: book)
        let favoriteStatus = isFav ? "Remove from favorites" : "Add to favorites"
        let plannedStatus = isPlanned ? "Remove from planned" : "Add to planned"
        let favImg = isFav ? "heart.fill" : "heart"
        let plannedImg = isPlanned ? "bookmark.fill" : "bookmark"
        return Group {
            Button {
                viewModel.toggleFavorite(book: book)
            } label: {
                Label(favoriteStatus, systemImage: favImg)
            }

            Button {
                shareManager.share(book)
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            Button {
                viewModel.toggleFutureReading(book: book)
            } label: {
                Label(plannedStatus, systemImage: plannedImg)
            }
        }
    }

    
    private func collectionView(_ geometry: GeometryProxy) -> some View {
        let width = (geometry.size.width / 2) - 20
        let clmns = [GridItem(.fixed( width)),GridItem(.fixed(width))]
        return VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: clmns,spacing: 20) {
                    ForEach(viewModel.books, id: \.id) { book in
                        BookCell(book: book,isFavorite: viewModel.isFavorite(book: book),isPlanned: viewModel.isPlanned(book: book)) { bookAction in
                            switch bookAction {
                                
                            case .favorite:
                                viewModel.toggleFavorite(book: book)
                            case .share:
                                shareManager.share(book)
                            case .bookmark:
                                viewModel.toggleFutureReading(book: book)
                            }
                        }
                        
                        .onTapGesture {
                            viewModel.navigationPath.append(BookIdentifiable(book: book))
                        }
                        .contextMenu {
                            contextMenuItems(book)
                        }
                        .frame(height: width * 1.5)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .refreshable {
                await viewModel.fetchBooks()
            }
            .padding(.top,90)
            .padding(.horizontal,10)
            .opacity(viewModel.isLoading ? 0 : 1)
        }
    }
    
    private var progressView: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(1.5)
            .tint(.black)
            .padding()
    }
    
    private var navigationButtons: some View {
        HStack {
            Button {
                withAnimation {
                    isSearchOpened.toggle()
                }
            } label: {
                createImage("magnifyingglass")
            }
            
            Button {
                withAnimation {
                    viewModel.isFilterOpened.toggle()
                }
            } label: {
                createImage("line.3.horizontal.decrease")
            }
        }
    }
    
    private var searchFieldView: some View {
        CustomSearchBar(searchResults: $viewModel.searchResults,placeholder: "Search", text: $viewModel.searchText) {
            isSearchOpened = false
        } onClose: {
            isSearchOpened = false
        }
        .foregroundStyle(.blackText)
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        .transition(.opacity)
    }
}


