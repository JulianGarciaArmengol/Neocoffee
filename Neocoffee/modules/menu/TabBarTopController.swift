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
        
    private var ajustmentSafeArea: UIEdgeInsets {
        UIEdgeInsets(
            top: tabBar.frame.height,
            left: 0.0,
            bottom: -tabBar.frame.height,
            right: 0.0
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
        
        pushTabBarTop()
        
        buildTabBarMenu()
        
        setBackgroundColors()
    }
    
    private func buildTabBarMenu() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )
        
        let favoritesVC = FavoritesViewController()
        favoritesVC.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart.fill"),
            tag: 1
        )
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.circle"),
            tag: 2
        )
        
        setViewControllers([homeVC, favoritesVC, profileVC], animated: false)
    }
    
    private func setBackgroundColors() {
        guard let count = tabBar.items?.count else { return }
        
        let itemWidth = tabBar.frame.width / CGFloat(count)
        
        for i in 0..<count {
            let bgColor = UIColor(named: "tabbar-\(i + 1)")
            let bgView = UIView(frame: CGRect.init(x: itemWidth * CGFloat(i), y: 0, width: itemWidth, height: tabBar.frame.height))
            bgView.backgroundColor = bgColor
            tabBar.insertSubview(bgView, at: 0)
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
    
}
