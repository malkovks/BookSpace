//
// File name: ContentView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 22.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI
import SwiftData

struct BookCollectionView: View {
    @EnvironmentObject var networkManager: NetworkMonitor
    @ObservedObject var viewModel: BookCollectionViewModel
    public var updateRightButtons: (_ buttons: AnyView) -> Void
    public var needToHideNavigation: (_ isHidden: Bool) -> Void
    
    @State private var isSearchOpened: Bool = false {
        didSet {
            withAnimation(.interpolatingSpring) {
                needToHideNavigation(isSearchOpened)
            }
        }
    }
    
    
    @StateObject private var shareManager = ShareManager()
    

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    collectionView(geometry)
                        .navigationDestination(for: BookIdentifiable.self) { bookWrapper in
                            BookDetailView(book: bookWrapper.book, isFavorite: viewModel.isFavorite(book: bookWrapper.book), isFutureReading: viewModel.isPlanned(book: bookWrapper.book)) {
                                viewModel.navigationPath.removeLast()
                            } isAddedToFavorite: { isFavorite in
                                viewModel.updateFavoriteBooks(bookWrapper.book, isFavorite)
                            } isAddedToReadLater: { isReadLater in
                                viewModel.updatePlannedBooks(bookWrapper.book, isReadLater)
                            }
                        }
                    
                    if viewModel.isFilterOpened {
                        filterView(geometry)
                    }
                    if !networkManager.isConnected {
                        networkMessage
                    }
                }
                .overlay {
                    if isSearchOpened {
                        searchFieldView
                    }
                    
                    if viewModel.isLoading {
                        progressView
                    }
                }
                
                .onAppear {
                    updateRightButtons(
                        AnyView(navigationButtons)
                    )
                    Task {
                        await viewModel.fetchBooks()
                    }
                }
                .onReceive(networkManager.$isConnected) { isConnected in
                    if !isConnected {
                        viewModel.showAlertView = true
                        viewModel.status = .error
                        viewModel.message = "No internet connection"
                    } else {
                        viewModel.showAlertView = false
                    }
                }
                
                .sheet(isPresented: $shareManager.isSharePresented) {
                    ShareSheet(items: shareManager.shareItems)
                }
                .statusNotification(isPresented: $viewModel.showAlertView, type: viewModel.status,message: viewModel.message, duration: 3.0)
            }
        }
        .background(Color.clear)
    }
    
    private func filterView(_ geometry: GeometryProxy) -> some View {
        FilterBooksView(filter: $viewModel.selectedFilter) {
            viewModel.isFilterOpened.toggle()
        }
        .frame(width: geometry.size.width / 2, height: geometry.size.height/3)
        .frame(minHeight: geometry.size.height/3, maxHeight: geometry.size.height/2)
        .position(x: geometry.size.width - geometry.size.width / 3, y: geometry.size.height/3)
        .transition(.move(edge: .trailing))
    }
    
    private func errorMessageView(_ message: String) -> some View {
        return Text(message)
            .foregroundColor(.secondary)
            .font(.title2)
            .minimumScaleFactor(0.5)
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
                viewModel.updateFavoriteBooks(book,isFav) { result in
                    displayMessage(isFav,type: .favorite)
                    viewModel.status = result
                    viewModel.showAlertView = true
                    
                }
            } label: {
                Label(favoriteStatus, systemImage: favImg)
            }

            Button {
                shareManager.share(book)
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            Button {
                viewModel.updatePlannedBooks(book,isPlanned) { result in
                    displayMessage(isPlanned,type: .planned)
                    viewModel.status = result
                    viewModel.showAlertView = true
                    
                }
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
                            case .favorite(let favorite):
                                viewModel.updateFavoriteBooks(book, favorite) { result in
                                    displayMessage(favorite, type: .favorite)
                                    viewModel.showAlertView = true
                                    viewModel.status = result
                                    
                                }
                            case .share:
                                shareManager.share(book)
                            case .bookmark(let planned):
                                viewModel.updatePlannedBooks(book,planned) { result in
                                    displayMessage(planned,type: .planned)
                                    viewModel.showAlertView = true
                                    viewModel.status = result
                                    
                                }
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
            .background(Color.clear)
        }
    }
    
    private func displayMessage(_ result: Bool, type: ValueType) {
        switch type {
        case .favorite:
            let text = !result ? "Book added to favorites" : "Book removed from favorites"
            viewModel.message = text
        case .planned:
            let text = !result ? "Book added to planned reading" : "Book removed from planned reading"
            viewModel.message = text
        }
        
    }
    
    private var networkMessage: some View {
        VStack {
            Spacer()
            Button {
                Task {
                    await viewModel.fetchBooks()
                }
            } label: {
                VStack(spacing: 2) {
                    Text("⚠️ Out of internet. Check connection and try again")
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                        .lineLimit(nil)
                    if let errorMessage = viewModel.errorMessage {
                        errorMessageView(errorMessage)
                    }
                    Text("Refresh")
                        .font(.caption)
                        .foregroundStyle(.updateBlue)
                }
            }
            Spacer()
        }
        .padding()
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
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


