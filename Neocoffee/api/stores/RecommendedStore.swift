//
//  RecommendedStore.swift
//  Neocoffee
//
//  Created by julian.garcia on 08/08/24.
//

import Foundation
import Combine

class RecommendedStore {
    
    var recommended = PassthroughSubject<[Recommended], Never>()
    
    func getRecommended() {
        let defaultRecommended: [Recommended] = [
            .init(id: 0, url: "to recommended 1", image: "sp1"),
            .init(id: 1, url: "to recommended 2", image: "sp2"),
            .init(id: 2, url: "to recommended 3", image: "sp3")
        ]
        
        recommended.send(defaultRecommended)
    }
}
