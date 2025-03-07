//
//  SplashViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 3/3/25.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let defaultStorage = DefaultsStorageImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigateToScreen()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func navigateToScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showNextScreen()
        }
    }
    
    func startOnboardingScreen() {
        defaultStorage.noFirstTimeLaunch = true
        let mainViewController = OnboardingViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        UIView.transition(with: keyWindow!,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            keyWindow?.rootViewController = navigationController
        },
                          completion: { _ in
            
        })
    }
    
    func startDashboardViewController(){
        let dashBoardViewcontroller = HomeViewController ()
        let navigationController = UINavigationController(rootViewController: dashBoardViewcontroller)
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        UIView.transition(with: keyWindow!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            keyWindow?.rootViewController = navigationController
        }, completion: { _ in })
    }
    
    func showNextScreen() {
        // Check if this is the first time the user opens the app
        if isFirstLaunch() {
            startOnboardingScreen()
        } else {
            startDashboardViewController()
        }
    }
    
    func isFirstLaunch() -> Bool {
        // Check if the user has viewed Onboarding
        return !defaultStorage.noFirstTimeLaunch
    }
}
