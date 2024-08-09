//
//  Desserts.swift
//  Neocoffee
//
//  Created by julian.garcia on 08/08/24.
//

import Foundation


import Foundation

// MARK: - Response
struct DessertResponse: Codable, Hashable {
    let success: Int
    let data: [Dessert]
    
    enum CodingKeys: String, CodingKey {
        case success = "SUCCESS"
        case data = "DATA"
    }
}

// MARK: - Dessert
struct Dessert: Codable, Hashable {
    let id: Int
    let name, image, date, description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "nombre"
        case image = "imagen"
        case date = "fecha_reg"
        case description = "descripcion"
    }
}

