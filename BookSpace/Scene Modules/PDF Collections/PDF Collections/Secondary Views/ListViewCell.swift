//
// File name: ListViewCell.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 27.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct ListViewCell: View {
    let file: SavedPDF
    let viewModel: PDFLibraryViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                createImage("document",primaryColor: .updateBlue,secondaryColor: .alertRed)
                Text(file.title)
                Text(file.dateAdded.formattedDate())
                    .font(.system(size: 12, weight: .light, design: .monospaced))
            }
            .padding()
            .frame(maxWidth: .infinity,minHeight: 200, maxHeight: 240,alignment: .center)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 2)
            }
            .onTapGesture {
                viewModel.selectedFile = file
                viewModel.navigationPath.append(.viewPDF(BookPDFIdentifiable(pdf: file)))
            }
            VStack {
                Button {
                    viewModel.textFieldName = file.title
                    viewModel.isChangeName.toggle()
                    viewModel.selectedPDF = file
                } label: {
                    createImage("square.and.pencil.circle",primaryColor: .updateBlue,secondaryColor: .alertRed)
                }
                Button {
                    viewModel.isDeleteFile.toggle()
                    viewModel.selectedPDF = file
                } label: {
                    createImage("trash",primaryColor: .alertRed,secondaryColor: .black)
                }
            }
        }
    }
}
