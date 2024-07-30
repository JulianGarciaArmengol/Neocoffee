//
//  NavBarTopViewController.swift
//  Neocoffee
//
//  Created by julian.garcia on 30/07/24.
//

import UIKit

protocol TabBarTopControllerSubView {
    func ajustSafeArea(additionalSafeAreaInsets: UIEdgeInsets)
}

class TabBarTopController: UITabBarController {
    
    var customViewTopConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .black
        tabBar.barTintColor = .white
        pushTabBarTop()
    }
    
    override func viewDidLayoutSubviews() {
        pushTabBarTop()
        super.viewDidLayoutSubviews()
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        viewControllers?.forEach { vc in
            if let vc = vc as? TabBarTopControllerSubView {
                vc.ajustSafeArea(additionalSafeAreaInsets: ajustmentSafeArea)
            }
        }
    }
    
    private func pushTabBarTop() {
        let height = view.safeAreaInsets.top
        tabBar.frame = CGRect(
            x: 0,
            y: height,
            width: tabBar.frame.size.width,
            height: tabBar.frame.size.height
        )
    }
    
    private var ajustmentSafeArea: UIEdgeInsets {
        UIEdgeInsets(
            top: tabBar.frame.height,
            left: 0.0,
            bottom: 0.0,
            right: 0.0
        )
    }
}
