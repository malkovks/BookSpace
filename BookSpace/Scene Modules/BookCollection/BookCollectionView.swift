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
    
    @State private var isFilterOpened: Bool = false
    @State private var selectedFilter: FilterCategories = .ebooks
    
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

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns,alignment: .center, spacing: 10) {
                            ForEach(0...9, id: \.self) { book in
                                Color.blue.opacity(0.4).frame(height: 200)
                            }
                        }
                    }
                    .padding(.top,80)
                    .padding()
                }
                
                if isFilterOpened {
                    FilterBooksView(filter: $selectedFilter) {
                        isFilterOpened.toggle()
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
                            withAnimation {
                                isFilterOpened.toggle()
                            }
                        } label: {
                            createImage("line.3.horizontal.decrease")
                        }
                    }))
            }
        }
        
    }
    
    private var searchFieldView: some View {
        CustomSearchBar(searchResults: $searchResults,placeholder: "Search", text: $viewModel.searchText) {
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
