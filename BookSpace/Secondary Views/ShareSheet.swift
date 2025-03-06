//
// File name: ShareSheet.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 06.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import UIKit
import SwiftUI

//Fix title preseting 
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.setValue("Check out this book from BookSpace", forKey: "subject")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
