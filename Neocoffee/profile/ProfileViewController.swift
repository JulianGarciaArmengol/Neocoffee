//
//  ProfileViewController.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import UIKit

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
}

extension ProfileViewController: TabBarTopControllerSubView {
    func ajustSafeArea(additionalSafeAreaInsets: UIEdgeInsets) {
        self.additionalSafeAreaInsets = additionalSafeAreaInsets
    }
}
