//
// File name: SettingsCoordinator.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 17.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

final class SettingsCoordinator {
    func makeView(
        settings: SettingsViewModel,
        rightButtons: @escaping (_ buttons: AnyView) -> Void
    ) -> some View {
        return SettingsView(updateRightButtons: rightButtons)
            .environmentObject(settings)
    }
}

