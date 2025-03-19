//
//  TabBarViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 19/3/25.
//

import UIKit

class TabBarViewController: UIViewController {
    
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var tabBarView: TabBarView!
    
    private var homeViewController: HomeViewController!
    private var resourcesViewController: ResourcesViewController!
    private var favoriteViewController: FavoriteViewController!
    private var supportViewController: SupportViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Custom UI
extension TabBarViewController {
    
    private func setupView(){
        tabBarView.delegate = self
        homeViewController = HomeViewController()
        resourcesViewController = ResourcesViewController()
        favoriteViewController = FavoriteViewController()
        supportViewController = SupportViewController()
        switchToViewController(homeViewController)
    }
    
    private func switchToViewController(_ viewController: UIViewController) {
        for child in children {
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        addChild(viewController)
        homeView.addSubview(viewController.view)
        viewController.view.frame = homeView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
}

// MARK: - TabBarDelegate
extension TabBarViewController: TabBarViewDelegate {
    
    func didTapHome() {
        switchToViewController(homeViewController)
    }
    
    func didTapResources() {
        switchToViewController(resourcesViewController)
    }
    
    func didTapFavorite() {
        switchToViewController(favoriteViewController)
    }
    
    func didTapSupport() {
        switchToViewController(supportViewController)
    }
}
