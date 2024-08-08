//
//  LoginViewController.swift
//  DataPersistenceSwiftData
//
//  Created by julian.garcia on 25/07/24.
//

import Foundation
import UIKit
import Combine

class LoginViewController: UIViewController {
    let loginViewModel = LoginViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.textContentType = .username
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textContentType = .password
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let card: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        setupViews()
        setupBindings()
        
        loginButton.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
    }
    
    @objc func crashButtonTapped() {
        print("muere")
        let numbers = [0]
        let _ = numbers[1]
    }
    
    private func setupViews() {
        view.addSubview(card)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signInButton)
        
        
        NSLayoutConstraint.activate([
            // username text field
            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // password text field
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 12),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // login Button
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // sign in Button
            signInButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            // card
            card.topAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -12),
            card.bottomAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 12),
            card.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            card.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
        ])
    }
    
    private func setupBindings() {
        loginViewModel.loggedUser
            .sink { user in
                let menuVC = TabBarTopController()
                menuVC.modalPresentationStyle = .fullScreen
                
                self.present(menuVC, animated: true)
            }.store(in: &cancellables)
    }
    
    
    @objc private func logInTapped() {
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        loginViewModel.loginWith(userName: username, password: password)
    }
    
    @objc private func signInTapped() {
        let viewController = SignInViewController()
        
        if let sheetController = viewController.sheetPresentationController {
            sheetController.detents = [.large()]
        }
        
        self.present(viewController, animated: true)
    }
}
