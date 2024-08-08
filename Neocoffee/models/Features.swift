//
//  Features.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import Foundation

enum Item: Hashable {
    case sectionBanner(Banner)
    case sectionFeatures(Features)
    case sectionRecommended([Recommended])
    
    var priority: Int {
        return switch self {
        case .sectionBanner(_ ):
            0
        case .sectionFeatures(_ ):
            1
        case .sectionRecommended(_ ):
            2
        }
    }
}

enum Section: Hashable, CaseIterable {
    case banner
    case features
    case recommended
    
    static func getByIndex(_ index: Int) -> Section {
        return switch index {
        case 0: .banner
        case 1: .features
        default: .recommended
        }
    }
}

struct Response: Identifiable, Hashable {
    let id: Int
    var banners: [Banner]
    var features: [Features]
    var recommended: [Recommended]
    
    
    var bannerItems: [Item] {
        banners.map { .sectionBanner($0) }
    }
    
    var featureItems: [Item] {
        features.map { .sectionFeatures($0) }
    }
    
    var recommendedItems: Item {
        .sectionRecommended(recommended)
    }
}

struct Banner: Identifiable, Hashable {
    let id: Int
    let url: String
    let image: String
}

struct Features: Identifiable, Hashable {
    let id: Int
    let url: String
    let image: String
}

struct Recommended: Identifiable, Hashable {
    let id: Int
    let url: String
    let image: String
}
