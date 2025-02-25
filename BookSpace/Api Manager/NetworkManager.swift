//
// File name: NetworkManager.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        
        //cache politits for request
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        //settings for url cache 20 mB in memory , 100 mb on disk storage
        configuration.urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "networkCache")
        
        
        //timeout settings for request and resources
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        
        configuration.httpMaximumConnectionsPerHost = 5
        
        self.session = URLSession(configuration: configuration)
    }
    
    public func createRequest(url: URL, method: String = "GET",headers: [String: String]? = nil, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeout: TimeInterval = 30) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeout)
        request.httpMethod = method
        headers?.forEach({ key, value in
            request.addValue(value, forHTTPHeaderField: key)
        })
        return request
    }
    
    public func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
}
