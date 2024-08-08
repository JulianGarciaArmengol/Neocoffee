//
//  SignInViewModel.swift
//  Neocoffee
//
//  Created by julian.garcia on 01/08/24.
//

import Foundation

@MainActor
final class SigninViewModel {
    var userStore: UserStore
    
    init(userStore: UserStore? = nil) {
        self.userStore = userStore ?? UserStore.shared
    }
    
    func createUserWith(name: String, mail: String, phone: String, password: String) {
        userStore.saveUser(name: name, mail: mail, phone: phone, password: password)
    }
}
