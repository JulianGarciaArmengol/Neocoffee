//
//  SigninViewController.swift
//  DataPersistenceSwiftData
//
//  Created by julian.garcia on 25/07/24.
//

import Foundation
import UIKit

class SignInViewController: UIViewController {
    let signinViewModel: SigninViewModel
    
    init(signinViewModel: SigninViewModel? = nil ) {
        self.signinViewModel = signinViewModel ?? SigninViewModel()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let textFieldName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "name"
        textField.textContentType = .username
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let textFieldMail: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Mail"
        textField.textContentType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let textFieldPassword: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textContentType = .newPassword
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let textFieldConfirmPassword: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.textContentType = .password
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let buttonCreateUser: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupViews()
        
        setupButtonAction()
    }
    
    private func setupViews() {
        view.addSubview(textFieldName)
        view.addSubview(textFieldMail)
        view.addSubview(textFieldPassword)
        view.addSubview(textFieldConfirmPassword)
        view.addSubview(buttonCreateUser)
        
        NSLayoutConstraint.activate([
            // username text field
            textFieldName.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            textFieldName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textFieldName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // email text field
            textFieldMail.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 12),
            textFieldMail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldMail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textFieldMail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // password text field
            textFieldPassword.topAnchor.constraint(equalTo: textFieldMail.bottomAnchor, constant: 12),
            textFieldPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textFieldPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            textFieldConfirmPassword.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 12),
            textFieldConfirmPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldConfirmPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textFieldConfirmPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // create user Button
            buttonCreateUser.topAnchor.constraint(equalTo: textFieldConfirmPassword.bottomAnchor, constant: 20),
            buttonCreateUser.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupButtonAction() {
        let action = UIAction(title: "create user") {[weak self] _ in
            self?.createButtonTapped()
        }
        
        buttonCreateUser.addAction(action, for: .primaryActionTriggered)
    }
    
    private func createButtonTapped() {
        guard let name = textFieldName.text, name.count > 3 else { return }
        guard let mail = textFieldMail.text, mail.count > 3  else { return }
        guard let password = textFieldPassword.text, password.count > 3  else { return }
        guard let confirmPassword = textFieldConfirmPassword.text,
              confirmPassword == password  else { return }
        
        guard password == confirmPassword else { return }
        
        signinViewModel.createUserWith(
            name: name,
            mail: mail,
            phone: "55555555",
            password: password
        )
        self.dismiss(animated: true)
    }
}
