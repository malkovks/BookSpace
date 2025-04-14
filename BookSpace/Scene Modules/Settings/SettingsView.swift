//
// File name: SettingsView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 26.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsViewModel
    @State private var isColorPickerPresented: Bool = false
    
    var updateRightButtons: (_ buttons: AnyView) -> Void
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .top) {
                Color.colorBackground
                    .ignoresSafeArea()
                formView
                    .padding(.top, 90)
            }
            .onAppear {
                updateRightButtons(AnyView(
                    Text("No buttons")
                ))
            }
        }
        
    }
    
    private var formView: some View {
        Form {
            Section {
                Picker("Select font", selection: $settings.selectedFont) {
                    Text("System").tag("System")
                    Text("Serif").tag("Serif")
                    Text("Monospaced").tag("Monospaced")
                }
            } header: {
                Text("Font")
            }
            
            Section {
                Slider(value: $settings.headerFontSize, in: 14...30, step: 1)
                    .tint(.skyBlue)
            } header: {
                Text("Header font size")
            }
            
            Section {
                HStack {
                    Text("Open Color picker")
                    Spacer()
                    Circle()
                        .foregroundStyle(settings.backgroundColor)
                        .frame(width: 30, height: 30)
                        
                }
            } header: {
                Text("App Background Font")
            }
            
            Section {
                Toggle("Camera access", isOn: $settings.isCameraAccessAllowed)
                    .tint(.skyBlue)
            } header: {
                Text("Access to camera")
            }
            
            Section {
                Picker("Mode", selection: $settings.appearanceMode) {
                    ForEach(SettingsViewModel.AppearanceMode.allCases) { mode in
                        Text(mode.rawValue.capitalized).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Application theme")
            }
            
            Section {
                Button {
                    print("Clean cache")
                } label: {
                    Text("Clean Cache")
                }
                
                Button {
                    print("Clean data")
                } label: {
                    Text("Clean data")
                }


            } header: {
                Text("Clean cache and data")
            }
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    let settings = SettingsViewModel()
        
        return SettingsView { buttons in
            
        }
        .environmentObject(settings)

}
