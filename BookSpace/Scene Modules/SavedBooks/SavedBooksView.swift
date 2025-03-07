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
    var navigateToBokCollection: () -> Void
    
    init(viewModel: SavedBooksViewModel, updateRightButtons: @escaping (_: AnyView) -> Void, navigateToBookCollection: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.updateRightButtons = updateRightButtons
        self.navigateToBokCollection = navigateToBookCollection
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                if !viewModel.isModelsEmpty {
                    collectionView
                } else {
                    emptyAlertView
                }

            }
            .onAppear {
                updateRightButtons(AnyView(
                    navigationView
            ))}
            .sheet(isPresented: $shareManager.isSharePresented) {
                ShareSheet(items: shareManager.shareItems)
            }
        }
    }
    
    private var collectionView: some View {
        ScrollView {
            List {
                ForEach(viewModel.savedBooks,id: \.id) { book in
                    SavedBookCell(book: book) {
                        print("add alert to delete book")
                        viewModel.remove(book: book)
                    } shareBook: {
                        shareManager.shareSavedBook(book)
                    } readLater: {
                        print("add func to view model for update read later status")
                    } updateRating: { rating in
                        viewModel.updateRating(for: book, rating: rating)
                    }
                }
            }
        }
    }
    
    private var emptyAlertView: some View {
        VStack(spacing: 20) {
            Text("No saved books yet")
                .foregroundColor(.secondary)
                .italic()
                .font(.largeTitle)
            Button {
                navigateToBokCollection()
            } label: {
                Label("Go to book collections", systemImage: "book.pages")
                    .foregroundStyle(.black)
                    .font(.headline)
            }
            .buttonStyle(.bordered)
        }
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

struct SavedBookCell: View {
    let book: SavedBooks
    
    var removeBook: (() -> Void)?
    var shareBook: (() -> Void)?
    var readLater: (() -> Void)?
    var updateRating: ((Int) -> Void)?
    
    
    init(book: SavedBooks, removeBook: (() -> Void)? = nil, shareBook: (() -> Void)? = nil,readLater: (() -> Void)? = nil, updateRating: ((Int) -> Void)? = nil) {
        self.book = book
        self.removeBook = removeBook
        self.shareBook = shareBook
        self.readLater = readLater
        self.updateRating = updateRating
    }
    
    @State private var scale: CGFloat = 1.0
    @State private var backgroundColor: Color = Color.secondary.opacity(0.2)
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 10) {
                coverView(size: geometry.size)
                infoView
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.secondary, lineWidth: 1)
            }
            .overlay(alignment: .topTrailing) {
                overlayButtons
            }
        }
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .scaleEffect(scale)
        .frame(maxWidth: .infinity,maxHeight: 200)
        .onTapGesture {
            withAnimation(.spring(response: 0.3,dampingFraction: 0.5,blendDuration: 0)) {
                scale = 0.95
            }
            withAnimation(.spring(response: 0.3,dampingFraction: 0.5,blendDuration: 0).delay(0.1)) {
                scale = 1
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                removeBook?()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)

        }
        .swipeActions(edge: .leading) {
            Button {
                print("add mark as readed")
            } label: {
                Label("Readed", systemImage: "checkmark.circle")
            }
            .tint(.green)

        }
        
        .onAppear {
            loadConverAndExtractColor()
        }
    }
    
    private var infoView: some View {
        VStack(alignment: .leading,spacing: 5) {
            InfoCell("", book.title, font: .headline)
            InfoCell("person", book.authors)
            InfoCell("list.bullet", book.category)
            InfoCell("calendar",book.publishedDate)
            InfoCell("calendar.badge.plus",book.createdAt.formattedDate())
            StarRatingView(rating: Binding(
                get: {
                    Int(book.averageRating ?? 0)
            }, set: { newRating in
                updateRating?(newRating)
            }))
        }
        .frame(alignment: .leading)
        .padding()
    }
    
    
    private var overlayButtons: some View {
        HStack(spacing: 5) {
            Button {
                print("toggle later read")
            } label: {
                createImage("bookmark",fontSize: 20)
            }

            Button {
                removeBook?()
            } label: {
                createImage("heart.fill",fontSize: 20)
            }
            
            Button {
                print("share")
            } label: {
                createImage("square.and.arrow.up",fontSize: 20)
            }
        }
        .padding([.top,.trailing], 10)
    }
    
    private func coverView(size: CGSize) -> some View {
        AsyncImage(url: URL(string: book.coverURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .tint(.black)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width / 3, height: size.height - 30)
            case .failure(_):
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width / 3, height: size.height - 30)
                    .foregroundStyle(.gray)
            @unknown default:
                EmptyView()
            }
        }
        .padding()
    }
    
    private func loadConverAndExtractColor() {
        guard let url = URL(string: book.coverURL) else { return }
        Task {
            do {
                let (data,_) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data),
                   let dominantColor = image.getDominantColor() {
                       await MainActor.run {
                           backgroundColor = Color(dominantColor)
                       }
                   }
            } catch {
                print("Error extracting color from image: \(error)")
            }
        }
    }
}

struct InfoCell: View {
    let icon: String
    let title: String
    let font: Font
    
    init(_ icon: String, _ title: String, font: Font = .subheadline) {
        self.icon = icon
        self.title = title
        self.font = font
    }
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
            Text(title)
                .font(font)
        }
    }
}

struct StarRatingView: View {
    @Binding var rating: Int
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundStyle(index <= rating ? .yellow : .gray)
                    .onTapGesture {
                        withAnimation {
                            rating = index
                        }
                    }
            }
        }
    }
}

#Preview {
    let book = SavedBooks(from: bookMockModel.first!)
    SavedBookCell(book: book)
}
