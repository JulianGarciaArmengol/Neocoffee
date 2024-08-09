//
//  Favorite.swift
//  Neocoffee
//
//  Created by julian.garcia on 08/08/24.
//

import Foundation

// MARK: - Response
struct FavoriteResponse: Codable {
    let success: Int
    let data: [Favorite]
    
    enum CodingKeys: String, CodingKey {
        case success = "SUCCESS"
        case data = "DATA"
    }
}

// MARK: - Favorite
struct Favorite: Codable, Hashable {
    let id: Int
    let name, user, date: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "nombre"
        case user = "usuario"
        case date = "fecha_reg"
    }
}
