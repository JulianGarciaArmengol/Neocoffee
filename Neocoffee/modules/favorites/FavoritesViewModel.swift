//
//  FavoritesViewModel.swift
//  Neocoffee
//
//  Created by julian.garcia on 31/07/24.
//

import Foundation
import Combine

final class FavoritesViewModel {
    var data = CurrentValueSubject<[Item], Never>([])
    private var dataStore: DataStore
    
    private var currentPage: Int = 0
    
    init(dataStore: DataStore = DataStore.shared) {
        self.dataStore = dataStore
    }
    
    func getItems() {
        var items = [Item]()
        
        items.append(dataStore.defaultData().bannerItems.first!)
        items.append(contentsOf: dataStore.getSavedItems())
        
        data.send(items)
    }
    
    func getNewItems() {
        var items = [Item]()
        currentPage += 1
        
        items.append(contentsOf: data.value)
        items.append(contentsOf: dataStore.getSavedItems(page: currentPage))
        
        print(items)
        
        data.send(items)
    }
    
    func deleteItemAt(indexPath: IndexPath) {
        var newData = data.value
        
        dataStore.removeItem(newData[indexPath.row])
        newData.remove(at: indexPath.row)
        
        data.send(newData)
    }
}
