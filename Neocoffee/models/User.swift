//
//  User.swift
//  Neocoffee
//
//  Created by julian.garcia on 01/08/24.
//

import Foundation
import SwiftData

@Model
class User {
    @Attribute(.unique) var id: UUID
    var name: String
    var mail: String
    var phone: String
    var password: String
    var address: String?
    
    init(
        name: String,
        mail: String,
        phone: String,
        password: String,
        address: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.mail = mail
        self.phone = phone
        self.password = password
        self.address = address
    }
}
