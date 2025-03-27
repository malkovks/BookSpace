//
// File name: BlurView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 27.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemThickMaterialLight
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
