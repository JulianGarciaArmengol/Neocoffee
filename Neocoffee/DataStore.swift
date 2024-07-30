//
//  DataStore.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import Foundation
import Combine

class DataStore {
    
    
    
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
                .init(id: 5, url: "to feature 6", image: "f6")
            ],
            recommended: [
                .init(id: 0, url: "to recommended 1", image: "sp1"),
                .init(id: 1, url: "to recommended 2", image: "sp2"),
                .init(id: 2, url: "to recommended 3", image: "sp3")
            ]
        )
    }
}
