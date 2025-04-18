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
            VStack(spacing: 10) {
                HStack {
                    searchField
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity,maxHeight: 80,alignment: .leading)
                .padding(15)
                .background(.paperYellow)
                Divider()
                    .background(Color.gray)
                    .padding(.horizontal)
            }
            .frame(maxHeight: .infinity,alignment: .top)
        }
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
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
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
