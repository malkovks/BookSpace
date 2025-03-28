//
// File name: CircleCloseButton.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 28.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct CircleCloseButton: View {
    
    var cancelAction: () -> Void
    
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                withAnimation {
                    cancelAction()
                }
            } label: {
                Circle()
                    .foregroundStyle(.paperYellow)
                    .frame(width: 40, height: 40, alignment: .center)
                    .overlay {
                        createImage("xmark")
                    }
                
            }
        }
        .padding([.top,.trailing],30)
        .shadow(radius: 2,x: 1,y: 2)
    }
}

