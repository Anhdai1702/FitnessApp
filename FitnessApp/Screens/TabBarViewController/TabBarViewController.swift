//
//  TabBarViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 19/3/25.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private let customTabBarView = TabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupCustomTabBar()
    }
}

// MARK: - Setup UI
extension TabBarViewController {
    
    private func setupViewControllers() {
        let viewControllersList: [UIViewController] = [
            HomeViewController(),
            ResourcesViewController(),
            FavoriteViewController(),
            SupportViewController()
        ].map { UINavigationController(rootViewController: $0) }
        
        viewControllers = viewControllersList
        selectedIndex = 0
    }
    
    private func setupCustomTabBar() {
        tabBar.isHidden = true
        
        customTabBarView.delegate = self
        view.addSubview(customTabBarView)
        
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBarView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}

// MARK: - TabBar Delegate
extension TabBarViewController: TabBarViewDelegate {
    func didSelectTab(at index: Int) {
        selectedIndex = index
    }
}
