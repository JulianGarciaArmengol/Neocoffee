//
//  UserStore.swift
//  DataPersistenceSwiftData
//
//  Created by julian.garcia on 25/07/24.
//

import Foundation
import SwiftData

enum UserStoreError: Error {
    case getUsersError
    case getUserError
}

@MainActor
class UserStore {
    static var shared = UserStore()
    
    private(set) var currentUser: User?
    
    var container: ModelContainer?
    var context: ModelContext?
    
    private init() {
        do {
            container = try ModelContainer(for: User.self)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            print(error)
        }
    }
    
    func saveUser(name: String, mail: String, phone: String, password: String) {
        guard let context else { return }
        
        let newUser = User(name: name, mail: mail, phone: phone, password: password)
        context.insert(newUser)
    }
    
    
    func getUserBy(userName: String, password: String) -> Result<User, UserStoreError> {
        guard let context else { return .failure(.getUserError) }
        
        var descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.name == userName && $0.password == password }
        )
        
        descriptor.fetchLimit = 1
        
        if let result = try? context.fetch(descriptor).first {
            currentUser = result
            return .success(result)
        } else {
            return .failure(.getUserError)
        }
    }
    
    func updateUser(
        name: String? = nil,
        mail: String? = nil,
        phone: String? = nil,
        address: String? = nil,
        password: String? = nil,
        image: String? = nil
    ) {
        guard let currentUser else { return }
        
        currentUser.name = name ?? currentUser.name
        currentUser.mail = mail ?? currentUser.mail
        currentUser.phone = phone ?? currentUser.phone
        currentUser.address = address ?? currentUser.address
        currentUser.password = password ?? currentUser.password
        currentUser.image = image ?? currentUser.image
    }
    
    func deleteUser(_ user: User) {
        guard let context else { return }
        
        context.delete(user)
    }
}
