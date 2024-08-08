//
//  MapViewModel.swift
//  Neocoffee
//
//  Created by julian.garcia on 31/07/24.
//

import Foundation
import Combine
import CoreLocation

final class MapViewModel {
    private let locationStore: LocationStore
    
    var stores = CurrentValueSubject<[Store]?, Never>(nil)
    
    init(locationStore: LocationStore = LocationStore()) {
        self.locationStore = locationStore
    }
    
    func getStores() {
        let stores = locationStore.defaultStores()
        
        self.stores.send(stores)
    }
}
