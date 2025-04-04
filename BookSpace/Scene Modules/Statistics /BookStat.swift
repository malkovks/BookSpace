//
// File name: BookStat.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 04.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct BookStat: Identifiable {
    let id = UUID()
    let category: BookCategory
    let count: Int
    let color: Color
    
    var percentage: Double {
        guard BookStat.totalCount > 0 else { return 0 }
        return Double(count) / Double(BookStat.totalCount)
    }
    
    var angleRange: (start: Angle, end: Angle) {
        let startPercent = BookStat.previousCategoriesPercentages[self.category] ?? 0
        let endPercent = startPercent + percentage
        return (start: .degrees(360 * startPercent), end: .degrees(360 * endPercent))
    }
    
    static var totalCount: Int = 0
    static var previousCategoriesPercentages: [BookCategory: Double] = [:]
}

extension BookStat {
    enum BookCategory: String, CaseIterable {
        case favorite
        case planned
        case read
        
        var title: String {
            switch self {
            case .favorite:
                return "Favorites"
            case .planned:
                return "Planned"
            case .read:
                return "Completed"
            }
        }
    }
    
    static func fromStats(favorites: Int, planned: Int, read: Int) -> [BookStat] {
        
        let total = favorites + planned + read
        BookStat.totalCount = total
        
        var stats: [BookStat] = []
        previousCategoriesPercentages.removeAll()
        
        
        var tempStats = [
            (category: BookCategory.favorite, count: favorites, color: Color.orange),
            (category: BookCategory.planned, count: planned, color: Color.blue),
            (category: BookCategory.read, count: read, color: Color.green)
        ].filter { $0.count > 0 }
        
        
        tempStats.sort { $0.count > $1.count }
        
        var currentStart: Double = 0
        for item in tempStats {
            let stat = BookStat(
                category: item.category,
                count: item.count,
                color: item.color
            )
            stats.append(stat)
            previousCategoriesPercentages[item.category] = currentStart
            currentStart += stat.percentage
        }
        
        return stats
    }
}
