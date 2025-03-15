//
// File name: StatusNotificationView+ Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 15.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

extension View {
    func statusNotification(isPresented: Binding<Bool>,type: Status, message: String? = nil, duration: Double = 2.0) -> some View {
        self.modifier(StatusNotificationModifier(isPresented: isPresented, type: type, message: message, duration: duration))
    }
}

struct StatusNotificationModifier: ViewModifier {
    @Binding var isPresented: Bool
    let type: Status
    var message: String?
    var duration: Double = 2.0
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                StatusNotificationView(type: type, message: message, duration: duration, isPresented: $isPresented)
                    .transition(.opacity)
            }
        }
    }
}
