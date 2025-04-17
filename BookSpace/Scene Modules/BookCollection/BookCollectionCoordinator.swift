//
// File name: BookCollectionCoordinator.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 17.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.
import SwiftUI
import SwiftData

@MainActor
final class BookCollectionCoordinator {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func makeView(
        rightButtons: @escaping (_ buttons: AnyView) -> Void,
        needToHideNavigation: @escaping (_ isHidden: Bool) -> Void
    ) -> some View {
        let vm = BookCollectionViewModel(modelContext: modelContext)
        return BookCollectionView(viewModel: vm, updateRightButtons: rightButtons, needToHideNavigation: needToHideNavigation)
    }
}

