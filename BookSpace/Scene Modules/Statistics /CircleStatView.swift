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
    
    init(viewModel: CircleStatViewModel,  updateRightButtons: @escaping (_: AnyView) -> Void, navigate: @escaping (_: BookStat.BookCategory) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.updateRightButtons = updateRightButtons
        self.navigateToSelectedCategory = navigate
    }
    
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ScrollView {
                VStack {
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                    } else {
                        BooksPieChartView(stats: viewModel.stats, navigateToCategory: navigateToSelectedCategory)
                            .frame(height: 400)
                            .padding(.top, 90)
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            updateRightButtons(AnyView(navigationView))
        }
        .task {
            await viewModel.fetchBoksStats()
        }
    }
    
    private var navigationView: some View {
        HStack {
            Button {
                print("start sorting stats")
            } label: {
                createImage("chart.pie.fill")
            }

        }
    }
}

struct BooksPieChartView: View {
    let stats: [BookStat]
    var navigateToCategory: (BookStat.BookCategory) -> Void
    @State private var selectedCategory: BookStat.BookCategory?
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
//        .background(
//            NavigationLink(
//                destination: destinationView,
//                isActive: <#T##Binding<Bool>#>,
//                label: <#T##() -> View#>
//            )
//        )
    }
    
//    @ViewBuilder
//    private var destinationView: some View {
//        navigateToCategory(self.selectedCategory ?? .favorite)
//    }
    
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
                PieSegment(data: stat)
                    .rotationEffect(.degrees(-90))
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
                HStack {
                    Circle()
                        .fill(stat.color)
                        .frame(width: 16, height: 16)
                    
                    VStack(alignment: .leading) {
                        Text(stat.category.title)
                            .font(.subheadline)
                        
                        Text("\(stat.count) books (\(Int(stat.percentage * 100))%)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedCategory == stat.category ? stat.color.opacity(0.2) : Color.clear)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedCategory = stat.category
                }
            }
        }
        .padding()
    }
}

struct PieSegment: View {
    let data: BookStat
    @State private var isSelected = false
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2
            
            Path { path in
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: data.angleRange.start,
                    endAngle: data.angleRange.end,
                    clockwise: false)
                path.closeSubpath()
                    
            }
            .fill(data.color)
            .overlay {
                Path { path in
                    path.move(to: center)
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: data.angleRange.start,
                        endAngle: data.angleRange.end,
                        clockwise: false)
                    path.closeSubpath()
                }
                .stroke(Color.black,lineWidth: isSelected ? 4 : 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
            .onTapGesture {
                isSelected = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    isSelected = false
                })
            }
            .overlay {
                percentageText(in: geometry)
                    
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    @ViewBuilder private func percentageText(in geometry: GeometryProxy) -> some View {
        let radius = min(geometry.size.width, geometry.size.height) / 2
        let middleAngle = (data.angleRange.start + data.angleRange.end) / 2
        let textRadius = radius * 0.7
        
        let x = textRadius * cos(CGFloat(middleAngle.radians))
        let y = textRadius * sin(CGFloat(middleAngle.radians))
        
        Text("\(Int(data.percentage * 100))%")
            .font(.system(size: min(radius / 5, 14), weight: .bold))
            .foregroundColor(.white)
            .shadow(color: .black, radius: 1)
            .frame(width: 40, height: 20)
            .background(Color.black.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .position(x: geometry.size.width / 2 + x, y: geometry.size.height / 2 + y)
            .opacity(data.percentage > 0.15 ? 1 : 0) 
    }

}
