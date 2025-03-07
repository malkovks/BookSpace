//
// File name: BookDetailView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 02.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct BookDetailView: View {
    let book: Book
    @State var isFavorite: Bool {
        didSet {
            isAddedToFavorite?(isFavorite)
        }
    }
    
    @State var isFutureReading: Bool {
        didSet {
            isAddedToReadLater?(isFutureReading)
        }
    }
    
    var onBack: () -> Void
    var isAddedToFavorite: ((_ isFavorite: Bool) -> Void)?
    var isAddedToReadLater: ((_ isReadLater: Bool) -> Void)?
    
    @StateObject private var viewModel = BookDetailViewModel()
    @StateObject private var shareManager = ShareManager()
    private var isFavoriteImageName: String {
        return isFavorite ? "heart.fill" : "heart"
    }
    private var isFutureReadingImageName: String {
        return isFutureReading ? "bookmark.fill" : "bookmark"
    }
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            viewModel.backgroundColor
                .ignoresSafeArea()
            List {
                AsyncImageView(url: book.volumeInfo.imageLinks.thumbnail,loadedImage: { image in
                    let image = Image(uiImage: image)
                    viewModel.extractColor(from: image)
                })
                
                
                .frame(height: 250,alignment: .center)
                .clipShape(.rect(cornerRadius: 10))
                .listRowBackground(Color.clear)
                
                ExpandableText(text: book.volumeInfo.description)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity,alignment: .center)
                Section {
                    DetailRow(title: "Name", value: book.volumeInfo.title)
                    DetailRow(title: "Authors", value: book.volumeInfo.authors.joined(separator: ", "))
                    DetailRow(title: "Category", value: book.volumeInfo.categories.joined(separator: ", "))
                    DetailRow(title: "Language", value: book.volumeInfo.language.capitalized)
                } header: {
                    Text("Main info")
                }
                .listRowBackground(Color.paperYellow.opacity(0.8))
                
                Section {
                    DetailRow(title: "Publisher", value: book.volumeInfo.publisher)
                    DetailRow(title: "Published Date", value: book.volumeInfo.publishedDate)
                    DetailRow(title: "Pages count", value: "\(book.volumeInfo.pageCount)")
                } header: {
                    Text("Additional info")
                }
                .listRowBackground(Color.paperYellow.opacity(0.8))
                
                
                
                Section {
                    DetailRow(title: "Maturing rating", value: book.volumeInfo.maturityRating)
                    if let averageRating = book.volumeInfo.averageRating {
                        DetailRow(title: "Average rating", value: "\(averageRating)")
                    }
                    if let ratingsCount = book.volumeInfo.ratingsCount {
                        DetailRow(title: "Ratings count", value: "\(ratingsCount)")
                    }
                } header: {
                    Text("Rating Info")
                }
                .listRowBackground(Color.paperYellow.opacity(0.8))
                
                LinkRow(title: "Link in store", url: book.volumeInfo.canonicalVolumeLink, systemImage: "link")
                LinkRow(title: "Link in Play Market", url: book.accessInfo.webReaderLink, systemImage: "storefront")
                Button {
                    shareManager.share(book)
                } label: {
                    HStack(alignment: .center) {
                        Text("Share")
                        Image(systemName: "square.and.arrow.up")
                    }
                    .frame(maxWidth: .infinity,alignment: .center)
                }
                .foregroundStyle(.black)
                

                
                
            }
            
            .sheet(isPresented: $shareManager.isSharePresented, content: {
                ShareSheet(items: shareManager.shareItems)
            })
            .listStyle(.insetGrouped)
            .padding(.top,80)
            navigationView
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var navigationView: some View {
        VStack {
            CustomNavigationBar(title: book.volumeInfo.title) {
                Button {
                    onBack()
                } label: {
                    createImage("chevron.left")
                }

            } rightButtons: {
                HStack {
                    Button {
                        isFavorite.toggle()
                    } label: {
                        createImage(isFavoriteImageName)
                    }
                    
                    Button {
                        isFutureReading.toggle()
                    } label: {
                        createImage(isFutureReadingImageName)
                    }
                }
            }
        }
    }
}

#Preview {
    BookDetailView(book: bookMockModel.first!,isFavorite: true,isFutureReading: true) {
        
    }
}
