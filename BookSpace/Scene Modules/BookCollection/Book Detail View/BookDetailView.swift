//
// File name: BookDetailView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 02.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct BookDetailView: View {
    let book: Book
    
    @StateObject private var viewModel = BookDetailViewModel()
    var onBack: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            viewModel.backgroundColor
                .ignoresSafeArea()
            List {
                AsyncImageView(url: book.volumeInfo.imageLinks.thumbnail,loadedImage: { image in
                    let image = Image(uiImage: image)
                    viewModel.extractColor(from: image)
                })
                
                
                .frame(height: 250)
                .clipShape(.rect(cornerRadius: 10))
                .listRowBackground(Color.clear)
                
                Text(book.volumeInfo.description)
                    .font(.system(.callout, design: .serif))
                    .italic()
                    .multilineTextAlignment(.center)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
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
                
                
            }
            
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
                        print("Add to favorite")
                    } label: {
                        createImage("heart")
                    }
                    
                    Button {
                        print("Read later")
                    } label: {
                        createImage("bookmark")
                    }
                }

            }
        }
        
    }
}

struct DetailRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.gray)
            Spacer()
            Text(value)
                .fontDesign(.monospaced)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct LinkRow: View {
    var title: String
    var url: String
    var systemImage: String
    
    var body: some View {
        HStack {
            Spacer()
            Link(title, destination: URL(string: url)!)
                .foregroundStyle(Color(uiColor: .blue))
            Image(systemName: systemImage)
                .foregroundStyle(Color(uiColor: .blue))
            Spacer()
            
        }
    }
}

#Preview {
    BookDetailView(book: bookMockModel.first!) {
        
    }
}
