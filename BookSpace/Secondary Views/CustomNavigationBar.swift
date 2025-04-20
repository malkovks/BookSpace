//
// File name: CustomNavigationBar.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

struct CustomNavigationBar<LeftButton: View, RightButtons: View>: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    let title: String
    
    let leftButton: LeftButton
    let rightButtons: RightButtons
    
    init(title: String, @ViewBuilder leftButton: () -> LeftButton, @ViewBuilder rightButtons: () ->  RightButtons) {
        self.title = title
        self.leftButton = leftButton()
        self.rightButtons = rightButtons()
    }
    
    var body: some View {
        HStack(spacing: 15) {
            leftButton
            Text(title)
                .font(.custom(settingsVM.selectedFont, size: settingsVM.headerFontSize))
                .fontWeight(settingsVM.isTextBold ? .black : .regular)
                .italic(settingsVM.isTextItalic)
                .underline(settingsVM.isTextUnderlined)
                .foregroundStyle(.blackText)
                .frame(maxWidth: .infinity,minHeight: 80, maxHeight: 80,alignment: .leading)
            HStack {
                rightButtons
            }
        }
        .padding(.horizontal,20)
        .background(.paperYellow)
    }
}
