//
//  Features.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import Foundation

enum Item: Hashable {
    case sectionBanner([Banner])
    case sectionFeatures([Features])
    case sectionRecommended([Recommended])
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
    var id: Int
    let banners: [Banner]
    let features: [Features]
    let recommended: [Recommended]
    
    
    var bannerItems: Item {
        .sectionBanner(banners)
    }
    
    var featureItems: Item {
        .sectionFeatures(features)
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
