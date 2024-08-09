//
//  DessertStore.swift
//  Neocoffee
//
//  Created by julian.garcia on 08/08/24.
//

import Foundation
import Combine

enum DessertStoreError: Error {
    case getDessertsError
    case decodeDessertsError
}

class DessertStore {
    private let endpoint = "https://eniadesign.com.mx/academia/api/"
    
    var desserts = PassthroughSubject<Result<[Dessert], DessertStoreError>, Never>()
    
    func getDesserts() {
        let url = URL(string: endpoint)!
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let data else {
                // send data error
                self?.desserts.send(.failure(.getDessertsError))
                return
            }
            
            guard let response = try? JSONDecoder().decode(DessertResponse.self, from: data) else {
                // send json error
                self?.desserts.send(.failure(.decodeDessertsError))
                return
            }
            
            // send data
            print(response.data)
            
            self?.desserts.send(.success(response.data))
            
        }.resume()
    }
}
