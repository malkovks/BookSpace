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
            print("search opened: \(isSearchOpened)")
            withAnimation(.interpolatingSpring) {
                needToHideNavigation(isSearchOpened)
            }
        }
    }
    
    var updateRightButtons: (_ buttons: AnyView) -> Void
    var needToHideNavigation: (_ isHidden: Bool) -> Void
    
    init(viewModel: BookCollectionViewModel, updateRightButtons: @escaping (_: AnyView) -> Void, needToHideNavigation: @escaping (_: Bool) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.updateRightButtons = updateRightButtons
        self.needToHideNavigation = needToHideNavigation
    }

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    collectionView
                        .navigationDestination(for: BookIdentifiable.self) { bookWrapper in
                            BookDetailView(book: bookWrapper.book) {
                                viewModel.navigationPath.removeLast()
                            }
                        }
                    
                    if viewModel.isFilterOpened {
                        FilterBooksView(filter: $viewModel.selectedFilter) {
                            viewModel.isFilterOpened.toggle()
                        }
                        .frame(width: geometry.size.width / 2, height: geometry.size.height/3)
                        .position(x: geometry.size.width - geometry.size.width / 3, y: geometry.size.height/3)
                        .transition(.move(edge: .trailing))
                    }
                }
                .overlay {
                    if isSearchOpened {
                        searchFieldView
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(1.5)
                            .tint(.black)
                            .padding()
                        
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
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
            }
        }
    }

    
    private var collectionView: some View {
        GeometryReader { geometry in
            let width = (geometry.size.width / 2) - 20
            let columns = [GridItem(.fixed(width)), GridItem(.fixed(width))]
            
            VStack {
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns,spacing: 20) {
                        ForEach(viewModel.books, id: \.id) { book in
                            BookCell(book: book,isFavorite: viewModel.isFavorite(book: book),isPlanned: viewModel.isPlanned(book: book)) { bookAction in
                                switch bookAction {
                                    
                                case .favorite:
                                    viewModel.toggleFavorite(book: book)
                                case .share:
                                    viewModel.shareSelectedBook(book)
                                case .bookmark:
                                    viewModel.toggleFutureReading(book: book)
                                }
                            }
                            .frame(height: width * 1.5)
                            .onTapGesture {
                                viewModel.navigationPath.append(BookIdentifiable(book: book))
                            }
                        }
                    }
                }
                .refreshable {
                    await viewModel.fetchBooks()
                }
                .padding(.top,80)
            }
            .opacity(viewModel.isLoading ? 0 : 1)
        }
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


