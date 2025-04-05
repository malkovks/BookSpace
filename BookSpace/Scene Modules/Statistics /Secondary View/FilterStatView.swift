//
// File name: FilterStatView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 05.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct FilterStatView: View {
    
    @Bindable var viewModel: CircleStatViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            BlurView(style: .regular)
                .onTapGesture {
                    dismiss()
                }
            GeometryReader { proxy in
                HStack(alignment: .top) {
                    Button {
                        dismiss()
                    } label: {
                        createImage("xmark")
                    }

                    Spacer()
                    VStack {
                        Text("Displayed Categories")
                            .minimumScaleFactor(0.5)
                            .font(.headline)
                        ForEach(BookStat.BookCategory.allCases, id: \.self) { stat in
                            VStack(alignment: .leading) {
                                Button {
                                    viewModel.toggleCategories(stat)
                                } label: {
                                    HStack(spacing: 5) {
                                        createImage(stat.icon,primaryColor: .updateBlue,secondaryColor: .black)
                                        Text(stat.title)
                                            .font(.callout)
                                            .foregroundStyle(Color.black)
                                        Spacer()
                                        createImage(viewModel.categories.contains(stat) ? "checkmark.circle" : "circle")
                                    }
                                }
                                Divider()
                            }
                            .padding(.top,10)
                            .padding(.horizontal,20)
                        }
                    }
                    .frame(width: proxy.size.width / 2)
                }
                .padding(.top, 90)
                .padding(.horizontal, 10)
            }
        }
        .ignoresSafeArea(.all)
    }
}
