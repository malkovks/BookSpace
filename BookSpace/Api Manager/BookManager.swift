//
// File name: BookManager.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 22.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


//MARK: - Api Key
// 'AIzaSyCFnAsKgGoe8AKu_Y_yVHvr5ULTJu6bpdQ'
// High-rated books by Google 'https://www.googleapis.com/books/v1/volumes?q=subject:fiction&orderBy=relevance&maxResults=10&key=AIzaSyCFnAsKgGoe8AKu_Y_yVHvr5ULTJu6bpdQ'

import Foundation

class GoogleBooksApi {
    private let apiKey: String = "AIzaSyCFnAsKgGoe8AKu_Y_yVHvr5ULTJu6bpdQ"
    private let baseUrl: String = "https://www.googleapis.com/books/v1/volumes"
    
    func fetchData(query: String, sortOption: BookSortOption = .newest,filter: FilterCategories = .ebooks) async throws -> BookResponse {
        guard let url = createURL(query: query, sort: sortOption,filter: filter).url else {
            throw  ApiErrorHandler.invalidURL
        }
        
        let request = NetworkManager.shared.createRequest(url: url, method: "GET",headers: ["Content-Type": "application/json"])
        
        let (data, response) = try await NetworkManager.shared.performRequest(request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ApiErrorHandler.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let booksResponse = try decoder.decode(BookResponse.self, from: data)
        return booksResponse
    }
    
    private func createURL(query: String, sort: BookSortOption,filter: FilterCategories) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.googleapis.com"
        components.path = "/books/v1/volumes"

        
        let searchQuery = query.isEmpty ? "subject:fiction" : query
        
        let queryItems = [
            URLQueryItem(name: "q", value: searchQuery),
            URLQueryItem(name: "orderBy", value: sort.urlValue),
            URLQueryItem(name: "filter", value: filter.urlValue),
            URLQueryItem(name: "maxResults", value: "10"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        components.queryItems = queryItems
        return components
    }
}
