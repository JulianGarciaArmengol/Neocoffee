//
//  LoginViewModel.swift
//  DataPersistenceSwiftData
//
//  Created by julian.garcia on 25/07/24.
//

import Foundation
import Combine
import FirebaseAnalytics

@MainActor
final class LoginViewModel {
    private let userStore = UserStore.shared
    
    let loggedUser = PassthroughSubject<User, Never>()
    
    func loginWith(userName: String, password: String) {
        let result = userStore.getUserBy(userName: userName, password: password)
        
        switch result {
        case .success(let user):
            
            Analytics.logEvent(AnalyticsEventLogin, parameters: [
                AnalyticsParameterMethod: "username and password"
            ])
            
            loggedUser.send(user)
        case .failure(let error):
            print("no usuario por acaa eseeee! " + error.localizedDescription)
        }
    }
}
