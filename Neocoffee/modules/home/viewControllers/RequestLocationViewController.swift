//
//  RequestLocationViewController.swift
//  Neocoffee
//
//  Created by julian.garcia on 09/08/24.
//

import Foundation
import UIKit
import CoreLocation

class RequestLocationViewController: UIViewController {
    
    private var locationManager = CLLocationManager()
    
    private var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        return view
    }()
    
    private var buttonCancel: UIButton = {
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
        view.setTitle("Cancelar", for: .normal)
        
        return view
    }()
    
    private var buttonGiveAccess: UIButton = {
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
        view.setTitle("Dar Permiso", for: .normal)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupActions()
        
        textView.text = """
                        Esta aplicación necesita acceder a tu ubicación para ofrecerte una mejor experiencia. Por favor, concede acceso a la ubicación en los ajustes de la aplicación.
                        """
        
    }
    
    private func setupViews() {
        view.addSubview(textView)
        view.addSubview(buttonCancel)
        view.addSubview(buttonGiveAccess)
        
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: buttonCancel.topAnchor, constant: -16),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            
            buttonCancel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonCancel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            buttonGiveAccess.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonGiveAccess.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupActions() {
        let actionCancel = UIAction {[weak self] _ in
            self?.dismiss(animated: true)
        }
        buttonCancel.addAction(actionCancel, for: .primaryActionTriggered)
        
        let actionGiveAccess = UIAction {[weak self] _ in
            
            self?.locationManager.delegate = self
            self?.locationManager.requestWhenInUseAuthorization()
            
        }
    }
}

extension RequestLocationViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            dismiss(animated: true) {
                self.present(MapViewController(), animated: true)
            }
        }
    }
}
