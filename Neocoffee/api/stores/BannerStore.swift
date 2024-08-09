//
//  BannerStore.swift
//  Neocoffee
//
//  Created by julian.garcia on 08/08/24.
//

import Foundation
import Combine

class BannerStore {
    
    var banners = PassthroughSubject<[Banner], Never>()
    
    func getBanners() {
        let defaultBanners: [Banner] = [
            .init(id: 0, url: "to banner 1", image: "bn1"),
            .init(id: 1, url: "to banner 2", image: "bn2"),
            .init(id: 3, url: "to banner 3", image: "bn3"),
            .init(id: 4, url: "to banner 4", image: "bn4")
        ]
        
        banners.send(defaultBanners)
    }
}
