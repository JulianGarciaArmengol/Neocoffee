//
//  DataStore.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import Foundation
import Combine

class DataStore {
    static var shared = DataStore()
    
    private var savedItems = Set<Item>(
        [.sectionFeatures(.init(id: 0, url: "to feature 1", image: "f1")),
         .sectionFeatures(.init(id: 1, url: "to feature 2", image: "f2")),
         .sectionFeatures(.init(id: 2, url: "to feature 3", image: "f3")),
         .sectionFeatures(.init(id: 3, url: "to feature 1", image: "f1")),
         .sectionFeatures(.init(id: 4, url: "to feature 2", image: "f2")),
         .sectionFeatures(.init(id: 5, url: "to feature 1", image: "f1")),
         .sectionFeatures(.init(id: 6, url: "to feature 2", image: "f2")),
         .sectionFeatures(.init(id: 7, url: "to feature 1", image: "f1")),
         .sectionFeatures(.init(id: 8, url: "to feature 2", image: "f2")),
         .sectionFeatures(.init(id: 9, url: "to feature 1", image: "f1")),
         .sectionFeatures(.init(id: 10, url: "to feature 2", image: "f2")),
         .sectionFeatures(.init(id: 11, url: "to feature 1", image: "f1")),
         .sectionFeatures(.init(id: 12, url: "to feature 2", image: "f2")),
         .sectionFeatures(.init(id: 13, url: "to feature 1", image: "f1")),
         .sectionFeatures(.init(id: 14, url: "to feature 2", image: "f2")),
         .sectionFeatures(.init(id: 15, url: "to feature 1", image: "f1")),
         .sectionFeatures(.init(id: 16, url: "to feature 2", image: "f2")),
         .sectionFeatures(.init(id: 17, url: "to feature 1", image: "f1")),
         .sectionFeatures(.init(id: 18, url: "to feature 2", image: "f2")),
         .sectionFeatures(.init(id: 19, url: "to feature 1", image: "f1")),
         .sectionFeatures(.init(id: 20, url: "to feature 2", image: "f2")),
         .sectionFeatures(.init(id: 21, url: "to feature 1", image: "f1")),
         .sectionFeatures(.init(id: 22, url: "to feature 2", image: "f2")),
         .sectionFeatures(.init(id: 23, url: "to feature 1", image: "f1")),
         .sectionFeatures(.init(id: 24, url: "to feature 2", image: "f2")),
        ]
    )
    
    func getFeatures(page: Int = 0) -> [Features] {
        let offset = page * 8
        
        return [
            .init(id: 0 + offset, url: "to banner \(0 + offset)", image: "f1"),
            .init(id: 1 + offset, url: "to banner \(1 + offset)", image: "f2"),
            .init(id: 2 + offset, url: "to banner \(2 + offset)", image: "f3"),
            .init(id: 3 + offset, url: "to banner \(3 + offset)", image: "f4"),
            .init(id: 4 + offset, url: "to banner \(4 + offset)", image: "f5"),
            .init(id: 5 + offset, url: "to banner \(5 + offset)", image: "f1"),
            .init(id: 6 + offset, url: "to banner \(6 + offset)", image: "f2"),
            .init(id: 7 + offset, url: "to banner \(7 + offset)", image: "f3"),
        ]
    }
    
    func getSavedItems(page: Int = 0) -> [Item] {
        let total: Int = savedItems.count
        let limit: Int = 8
        let start: Int = page == 0 ? 0 : (limit * page) - limit
        var end: Int = start + limit
        end = end >= total ? total : end
        end = end - 1
        let data  = start >= total ? [] : Array(savedItems)[start...end]
        
        return Array(data)
    }
    
    func SaveItem(_ item: Item) {
        savedItems.insert(item)
    }
    
    func removeItem(_ item: Item) {
        savedItems.remove(item)
    }
    
    func defaultData() -> Response {
        Response(
            id: 0,
            banners: [
                .init(id: 0, url: "to banner 1", image: "bn1"),
                .init(id: 1, url: "to banner 2", image: "bn2"),
                .init(id: 3, url: "to banner 3", image: "bn3"),
                .init(id: 4, url: "to banner 4", image: "bn4")
            ],
            features: [
                .init(id: 0, url: "to feature 1", image: "f1"),
                .init(id: 1, url: "to feature 2", image: "f2"),
                .init(id: 2, url: "to feature 3", image: "f3"),
                .init(id: 3, url: "to feature 4", image: "f4"),
                .init(id: 4, url: "to feature 5", image: "f5"),
                .init(id: 5, url: "to feature 6", image: "f1"),
                .init(id: 6, url: "to feature 4", image: "f2"),
                .init(id: 7, url: "to feature 5", image: "f3")
            ],
            recommended: [
                .init(id: 0, url: "to recommended 1", image: "sp1"),
                .init(id: 1, url: "to recommended 2", image: "sp2"),
                .init(id: 2, url: "to recommended 3", image: "sp3")
            ]
        )
    }
}
