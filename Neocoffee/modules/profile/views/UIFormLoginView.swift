//
//  UIFormLoginView.swift
//  Neocoffee
//
//  Created by julian.garcia on 31/07/24.
//

import UIKit

class UIFormLoginView: UIView {
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "person.fill")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.text = "Nombre del usuario"
        return view
    }()
    let emailLabel: UILabel = {
        let view = UILabel()
        view.text = "Email"
        return view
    }()
    let phoneLabel: UILabel = {
        let view = UILabel()
        view.text = "Phone"
        return view
    }()
    let addressLabel: UILabel = {
        let view = UILabel()
        view.text = "Address"
        return view
    }()
    
    var detailsView: UIStackView!
    
    let fieldUsername: UITextField = {
        let view = UITextField()
        view.placeholder = "Nombre de usuario"
        view.borderStyle = .line
        return view
    }()
    
    let fieldEmail: UITextField = {
        let view = UITextField()
        view.placeholder = "Email"
        view.borderStyle = .line
        return view
    }()
    
    let fieldPhone: UITextField = {
        let view = UITextField()
        view.placeholder = "Phone"
        view.borderStyle = .line
        return view
    }()
    
    let fieldAddress: UITextField = {
        let view = UITextField()
        view.placeholder = "Address"
        view.borderStyle = .line
        return view
    }()
    
    var formView: UIStackView!
    
    var buttonUpdate: UIButton = {
        
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = UIColor(named: "button-background")
        configuration.contentInsets = .init(
            top: 0,
            leading: 30,
            bottom: 0,
            trailing: 30
        )
        
        let view = UIButton(configuration: configuration)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 15
        
        view.setTitleColor(UIColor.gray, for: .normal)
        view.setTitle("Actualizar", for: .normal)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        detailsView = {
            let view = UIStackView(arrangedSubviews: [
                nameLabel, emailLabel, phoneLabel, addressLabel
            ])
            
            view.axis = .vertical
            view.spacing = 6
            view.alignment = .leading
            view.isLayoutMarginsRelativeArrangement = true
            
            return view
        }()
        
        formView = {
            
            let titleLabel: UILabel = {
                let view = UILabel()
                view.text = "Editar perfil"
                return view
            }()
            
            let view = UIStackView(arrangedSubviews: [
                titleLabel, fieldUsername, fieldEmail, fieldPhone, fieldAddress
            ])
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .vertical
            view.alignment = .fill
            view.distribution = .fillProportionally
            view.spacing = 12
            
            return view
        }()
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        
        
        // details
        let detailsStack = UIStackView(arrangedSubviews: [
            profileImageView,
            detailsView
        ])
        detailsStack.translatesAutoresizingMaskIntoConstraints = false
        detailsStack.axis = .horizontal
        detailsStack.spacing = 12
        detailsStack.distribution = .fillProportionally
        detailsStack.alignment = .fill
        addSubview(detailsStack)
        
        // separator
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        
        
        // form
        addSubview(formView)
        
        // button
        addSubview(buttonUpdate)
        
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            detailsStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            detailsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            detailsStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            separator.topAnchor.constraint(equalTo: detailsStack.bottomAnchor, constant: 20),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 2),
            
            formView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 16),
            formView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            formView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            buttonUpdate.topAnchor.constraint(equalTo: formView.bottomAnchor, constant: 24),
            buttonUpdate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonUpdate.heightAnchor.constraint(equalToConstant: 30.0)
        ])
    }
    
}
