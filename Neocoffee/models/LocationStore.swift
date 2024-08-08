//
//  LocationStore.swift
//  Neocoffee
//
//  Created by julian.garcia on 01/08/24.
//

import Foundation

struct LocationStore {
    
    func defaultStores() -> [Store] {
        [
            .init(
                id: 0,
                name: "NeoCafe Reforma",
                latitude: 19.4269903,
                longitude: -99.1676463
            )
        ]
    }
}

struct Store {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
}
