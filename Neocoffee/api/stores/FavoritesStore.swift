//
//  DataStore.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import Foundation
import Combine

enum FavoritesStoreError: String, Error {
    case urlError = "url error"
    case urlRequestBodyError = "url request body error"
    case urlSessionDataError = "urs session data error"
    case jsonDecodeError = "json decode error"
}

class FavoritesStore {
    private let endpoint = "https://eniadesign.com.mx/academia/api/"
    private let POST_FAVORITE_API_KEY = "20240708"
    private let GET_FAVORITE_API_KEY = "20240709"
    
    var favorites = PassthroughSubject<Result<[Favorite], FavoritesStoreError>, Never>()
    
    func getFavorites(email: String) {
        guard let url = URL(string: endpoint) else {
            self.favorites.send(.failure(.urlError))
            return
        }
        
        let body: [String: Any] = [
            "apiKey": GET_FAVORITE_API_KEY,
            "email": email
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.percentEncoded()
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let data else {
                self?.favorites.send(.failure(.urlSessionDataError))
                return
            }
            
            guard let response = try? JSONDecoder().decode(FavoriteResponse.self, from: data) else {
                self?.favorites.send(.failure(.jsonDecodeError))
                return
            }
                        
            self?.favorites.send(.success(response.data))
            
        }.resume()
        
    }
    
    func saveFavorite(email: String, dessert: Dessert) {
        guard let url = URL(string: endpoint) else {
            // TODO: send error
            self.favorites.send(.failure(.urlError))
            return
        }
        
        let body: [String: Any] = [
            "apiKey": POST_FAVORITE_API_KEY,
            "producto": dessert.name,
            "email": email
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.percentEncoded()
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let data else {
                self?.favorites.send(.failure(.urlSessionDataError))
                return
            }
            
            guard let response = try? JSONDecoder().decode(FavoriteResponse.self, from: data) else {
                self?.favorites.send(.failure(.jsonDecodeError))
                return
            }
            
            self?.favorites.send(.success(response.data))
            
        }.resume()
        
    }
    
    func deleteFavorite(email: String, dessert: Favorite) {
        guard let url = URL(string: endpoint) else {
            self.favorites.send(.failure(.urlError))
            return
        }
        
        let body: [String: Any] = [
            "apiKey": POST_FAVORITE_API_KEY,
            "producto": dessert.name,
            "email": email,
            "action": "remove"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.percentEncoded()
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let data else {
                self?.favorites.send(.failure(.urlSessionDataError))
                return
            }
            
            guard let response = try? JSONDecoder().decode(FavoriteResponse.self, from: data) else {
                self?.favorites.send(.failure(.jsonDecodeError))
                return
            }
            
            self?.favorites.send(.success(response.data))
            
        }.resume()
    }
}
