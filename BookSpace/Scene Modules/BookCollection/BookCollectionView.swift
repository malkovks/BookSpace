//
// File name: ContentView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 22.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI
import SwiftData

struct BookCollectionView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = BookCollectionViewModel()
    
    @State var isSearchOpened: Bool = false {
        didSet {
            print("search opened: \(isSearchOpened)")
            withAnimation(.interpolatingSpring) {
                needToHideNavigation(isSearchOpened)
            }
            
        }
    }
    
    var updateRightButtons: (_ buttons: AnyView) -> Void
    var needToHideNavigation: (_ isHidden: Bool) -> Void
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    collectionView
                        .navigationDestination(for: BookIdentifiable.self) { bookWrapper in
                            BookDetailView(book: bookWrapper.book)
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
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns,alignment: .center, spacing: 10) {
                    ForEach(viewModel.books, id: \.id) { book in
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
                        .padding()
                        .foregroundStyle(.blackText)
                        .background(Color.paperYellow)
                        .clipShape(.rect(cornerRadius: 10))
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
            .padding()
        }
        .opacity(viewModel.isLoading ? 0 : 1)
        
        
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



#Preview {
    BookCollectionView { buttons in
        
    } needToHideNavigation: { isHidden in
        
    }

}
