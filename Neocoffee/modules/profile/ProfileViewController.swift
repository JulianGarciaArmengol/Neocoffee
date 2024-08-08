//
//  ProfileViewController.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import UIKit
import FirebaseAnalytics

class ProfileViewController: UIViewController {
    
    let loginFormView: UIFormLoginView = {
        let view = UIFormLoginView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        view.backgroundColor = UIColor(named: "background")
        
        loginFormView.buttonUpdate.addAction(
            UIAction(handler: {[unowned self] _ in
                var name = self.loginFormView.fieldUsername.text
                var mail = self.loginFormView.fieldEmail.text
                var phone = self.loginFormView.fieldPhone.text
                var address = self.loginFormView.fieldAddress.text
                
                name = name!.count > 3 ? name : nil
                mail = mail!.count > 3 ? mail : nil
                phone = phone!.count > 3 ? phone : nil
                address = address!.count > 3 ? address : nil
                
                UserStore.shared.updateUser(
                    name: name,
                    mail: mail,
                    phone: phone,
                    address: address
                )
                self.updateUserDetails()
            }),
            for: .touchUpInside
        )
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        imageTap.numberOfTapsRequired = 1
        loginFormView.profileImageView.isUserInteractionEnabled = true
        loginFormView.profileImageView.addGestureRecognizer(imageTap)
        
        updateUserDetails()
        loadImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Analytics.logEvent("profile_open", parameters: [:])
    }
    
    func setupViews() {
        view.addSubview(loginFormView)
        
        NSLayoutConstraint.activate([
            loginFormView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            loginFormView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginFormView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginFormView.heightAnchor.constraint(greaterThanOrEqualToConstant: 500),
        ])
    }
    
    func updateUserDetails() {
        guard let user = UserStore.shared.currentUser else { return }
        
        loginFormView.nameLabel.text = user.name
        loginFormView.emailLabel.text = user.mail
        loginFormView.phoneLabel.text = user.phone
        loginFormView.addressLabel.text = user.address ?? "Address"
        
    }
    
    @objc private func handleImageTap() {
        let alert = UIAlertController(title: "Selecciona una imagen", message: nil, preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { _ in
            print("open camera")
            self.openCamera()
        }
        
        let actionLibrary = UIAlertAction(title: "Library", style: .default) {[unowned self] _ in
            print("open library")
            self.openPhotoLibrary()
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            print("cancel")
        }
        
        alert.addAction(actionCamera)
        alert.addAction(actionLibrary)
        alert.addAction(actionCancel)
        
        present(alert, animated: true)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }
    }
    
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }
    }
    
    private func saveImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("profile-image.jpg")
            do {
                try data.write(to: filename)
                print("Image saved")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadImage() {
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("profile-image.jpg")
                
        if let image = UIImage(contentsOfFile: filename.relativePath) {
            print(image.size)
            loginFormView.profileImageView.image = image
        } else {
            print("No image to load")
        }
    }
}

extension ProfileViewController: TabBarTopControllerSubView {
    func ajustSafeArea(additionalSafeAreaInsets: UIEdgeInsets) {
        self.additionalSafeAreaInsets = additionalSafeAreaInsets
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        loginFormView.profileImageView.image = newImage
        saveImage(newImage)
        
        dismiss(animated: true)
    }
}
