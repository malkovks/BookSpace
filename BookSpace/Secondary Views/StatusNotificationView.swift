//
// File name: StatusNotificationView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 15.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI



struct StatusNotificationView: View {
    let type: Status
    var message: String?
    var duration: Double = 2.0
    @Binding var isPresented: Bool
    
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: type.image)
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75, alignment: .top)
                .foregroundStyle(type.color)
            Text(type.title)
                .font(.headline)
                .multilineTextAlignment(.center)
            if let message = message {
                Text(message)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .onTapGesture {
            withAnimation() {
                isPresented = false
            }
        }
        .padding()
        .frame(width: 200, height: 200, alignment: .center)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 12))
        .shadow(radius: 8)
        .onAppear {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(type == .success ? .success : .error)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                withAnimation {
                    isPresented = false
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isPresented)
        
    }
}
