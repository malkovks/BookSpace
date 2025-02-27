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
    
    @State private var searchResults: [String] = ["SwiftUI", "UIKit", "Combine", "Core Data"]
    @State var isSearchOpened: Bool = false {
        didSet {
            print("search opened: \(isSearchOpened)")
            withAnimation(.interpolatingSpring) {
                needToHideNavigation(isSearchOpened)
            }
            
        }
    }
    var searchText: String = ""
    
    var updateRightButtons: (_ buttons: AnyView) -> Void
    var needToHideNavigation: (_ isHidden: Bool) -> Void
    
    var columns: [GridItem] = Array(repeating: GridItem(.flexible(),spacing: 10), count: 2)
    var mockData: [BookModel] =  [BookModel(),
                                  BookModel(),
                                  BookModel(),
                                  BookModel(),
                                  BookModel(),
                                  BookModel(),
                                  BookModel(),
                                  BookModel(),
                                  BookModel()]

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                    
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns,alignment: .center, spacing: 10) {
                        ForEach(0...9, id: \.self) { book in
                            Color.red.frame(height: 200)
                        }
                    }
                }
                .opacity(isSearchOpened ? 0 : 1)
                .padding()
            }
        }
        .overlay {
            if isSearchOpened {
                searchFieldView
            }
        }
        .onAppear {
            updateRightButtons(AnyView(
                HStack {
                    Button {
                        withAnimation {
                            isSearchOpened.toggle()
                        }
                    } label: {
                        createImage("magnifyingglass")
                    }
                    
                    Button {
                        print("filter items")
                    } label: {
                        createImage("line.3.horizontal.decrease")
                    }
                }))
        }
    }
    
    private var searchFieldView: some View {
        CustomSearchBar(searchResults: searchResults,placeholder: "Search", text: $viewModel.searchText) {
            isSearchOpened = false
        } onClose: {
            isSearchOpened = false
        }
        .foregroundStyle(.yellow)
        .background(Color(.lightGray))
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        .transition(.move(edge: .top).combined(with: .slide))
        .opacity(isSearchOpened ? 1 : 0)
    }
}

struct BookModel {
    let id: UUID = UUID()
    let image: Image = .init(systemName: "info.circle")
    let title: String = "Example"
}

#Preview {
    BookCollectionView { buttons in
        
    } needToHideNavigation: { isHidden in
        
    }

}
