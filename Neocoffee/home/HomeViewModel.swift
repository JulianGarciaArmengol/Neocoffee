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
    
    init(dataStore: DataStore = DataStore()) {
        self.dataStore = dataStore
        
        self.data.send(dataStore.defaultData())
    }
}
