//
// File name: CustomSearchBar.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

struct CustomSearchBar: View {
    
    @Binding var searchResults: [String]
    
    @FocusState private var isFocusedField: Bool
    private var filteredResults: [String] {
        if text.isEmpty {
            return searchResults
        } else {
            return searchResults.filter { $0.lowercased().contains(text.lowercased()) }
        }
    }
    
    let placeholder: String
    @Binding var text: String
    var onCommit: () -> Void
    var onClose: () -> Void
    
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.opacity(0.4)
                .blur(radius: 10)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        onClose()
                    }
                }
            
            VStack(spacing: 10) {
                HStack {
                    searchField
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity,maxHeight: 80,alignment: .leading)
                .padding(15)
                .background(.skyBlue)
                
                listView
            }
            .background(.thickMaterial, in: .rect(cornerRadius: 16))
        }
    }

    private var listView: some View {
        List(filteredResults, id: \.self) { result in
            HStack {
                Button {
                    print("selected result: \(result)")
                } label: {
                    Text(result)
                }
                Spacer()
                createImage("arrow.right",secondaryColor: .red)
                    .opacity(0.4)
            }
            .listRowBackground(Color.skyBlue)
        }
        .scrollContentBackground(.hidden)
        .foregroundStyle(.black)
        .listStyle(.insetGrouped)
        .frame(maxWidth: .infinity)
        .transition(.opacity)
    }
    
    private var searchField: some View {
        HStack {
            createImage("magnifyingglass",fontSize: 18)
                .padding([.vertical,.leading],20)
            TextField(placeholder, text: $text,onCommit: onCommit)
                .focused($isFocusedField)
                .autocorrectionDisabled(true)
                .keyboardType(.asciiCapable)
                .textContentType(.name)
                .textInputAutocapitalization(.never)
            Button {
                onClose()
            } label: {
                createImage("xmark",fontSize: 18)
            }
            .padding(10)
            .opacity(isFocusedField ? 1 : 0)
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isFocusedField = false
                }
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .frame(height: 40)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 1)
        }
    }
}

#Preview {
    
    
    CustomSearchBar(searchResults: .constant(["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth", "Tenth"]), placeholder: "Enter request", text: .constant("")) {
        
    } onClose: {
    
    }

}
