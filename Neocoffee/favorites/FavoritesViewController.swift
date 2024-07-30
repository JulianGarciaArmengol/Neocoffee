//
//  FavoritesViewController.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import UIKit

class FavoritesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
}

extension FavoritesViewController: TabBarTopControllerSubView {
    func ajustSafeArea(additionalSafeAreaInsets: UIEdgeInsets) {
        self.additionalSafeAreaInsets = additionalSafeAreaInsets
    }
}
