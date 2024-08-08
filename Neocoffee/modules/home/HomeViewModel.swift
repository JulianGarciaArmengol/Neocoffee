//
//  HomeViewModel.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import Foundation
import Combine

final class HomeViewModel {
    private let dataStore: DataStore
    
    var data = CurrentValueSubject<Response?, Never>(nil)
    
    var selectedFeature = PassthroughSubject<Features, Never>()
    
    init(dataStore: DataStore = DataStore.shared) {
        self.dataStore = dataStore
        
        self.data.send(dataStore.defaultData())
    }
    
    func getFeatures(page: Int) {
        var newData = data.value
        
        newData?.features.append(contentsOf: dataStore.getFeatures(page: page))
        
        data.send(newData)
    }
    
    func didSelectFeatureAt(_ indexPath: IndexPath) {
        guard let value = data.value else { return }
        selectedFeature.send(value.features[indexPath.row])
    }
}
