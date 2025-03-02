//
// File name: Image+Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 02.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

extension Image {
    func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let renderer = UIGraphicsImageRenderer(size: view!.bounds.size)
        return renderer.image { _ in view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)}
    }
}
