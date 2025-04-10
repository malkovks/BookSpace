//
// File name: CircleStatView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 04.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

struct CircleStatView: View {
    @StateObject private var viewModel: CircleStatViewModel
    
    var updateRightButtons: (_ buttons: AnyView) -> Void
    var navigateToSelectedCategory: (_ category: BookStat.BookCategory) -> Void
    @State private var selectedCategory: BookStat.BookCategory?
    @State private var isFilterOpened: Bool = false
    
    init(viewModel: CircleStatViewModel,  updateRightButtons: @escaping (_: AnyView) -> Void, navigate: @escaping (_: BookStat.BookCategory) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.updateRightButtons = updateRightButtons
        self.navigateToSelectedCategory = navigate
    }
    
    
    var body: some View {
        NavigationStack() {
            ZStack(alignment: .center){
                Color.secondary
                    .opacity(0.4)
                    .ignoresSafeArea()
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
                } else {
                    ScrollView {
                        VStack(alignment: .center) {
                            BooksPieChartView(
                                stats: $viewModel.filteredStats,
                                selectedCategory: $selectedCategory,
                                navigateToCategory: navigateToSelectedCategory)
                            .frame(height: 400)
                            
                            Spacer()
                        }
                        
                    }
                    .padding(.top, 80)
                    .frame(maxHeight: .infinity)
                }
            }
        }
        .onAppear {
            updateRightButtons(AnyView(navigationView))
        }
        //график не меняется после обновления фильтра. Исправить
        .fullScreenCover(isPresented: $isFilterOpened, content: {
            FilterStatView(viewModel: viewModel) {
//                Task {
//                    await viewModel.fetchBooksStats()
//                }
            }
        })
        
        .task {
            await viewModel.fetchBooksStats()
        }
    }
    
    private var navigationView: some View {
        HStack {
            Button {
                isFilterOpened.toggle()
            } label: {
                createImage("chart.pie.fill")
            }
        }
    }
}

struct BooksPieChartView: View {
    @Binding var stats: [BookStat]
    @Binding var selectedCategory: BookStat.BookCategory?
    var navigateToCategory: (BookStat.BookCategory) -> Void
    @State private var animationProgress: Double = 0
    
    var body: some View {
        VStack {
            if stats.isEmpty || (stats.count == 1 && stats.first?.color == .gray) {
                emptyCircle
            } else {
                pieCharts
                legendView
            }
            
        }
    }
    
    private var emptyCircle: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 200, height: 200)
            Text("No statistics yet")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var pieCharts: some View {
        ZStack {
            ForEach(stats) { stat in
                PieSegment(
                    data: stat,
                    isSelected: selectedCategory == stat.category,
                    onSelect: {
                        selectedCategory = stat.category
                        navigateToCategory(stat.category)
                    }
                )
                .opacity(animationProgress)
                .animation(
                    .easeInOut(duration: 0.5)
                    .delay(0.1 * Double(stats.firstIndex(where: { $0.id == stat.id }) ?? 0)),
                    value: animationProgress
                )
            }
        }
        .frame(width: 200, height: 200)
        .padding()
        .onAppear {
            animationProgress = 1
        }
    }
    
    private var legendView: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(stats) { stat in
                LegendRowView(stat: stat, isSelected: selectedCategory == stat.category) {
                    selectedCategory = stat.category
                    navigateToCategory(stat.category)
                }
            }
        }
        .padding()
    }
}




