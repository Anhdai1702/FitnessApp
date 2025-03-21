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
        updateLanguageIfNeeded()
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
    
    func loginViewController(){
        defaultStorage.loggedInUserIdKey = true
        let dashBoardViewcontroller = LoginViewController ()
        let navigationController = UINavigationController(rootViewController: dashBoardViewcontroller)
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        UIView.transition(with: keyWindow!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            keyWindow?.rootViewController = navigationController
        }, completion: { _ in })
    }
    
    func homeViewController(){
        let dashBoardViewcontroller = TabBarViewController ()
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
            if isLoggedIn() {
                loginViewController()
            }
            else {
                homeViewController()
            }
        }
    }
    
    // Check if the user has viewed Onboarding
    func isFirstLaunch() -> Bool {
        return !defaultStorage.noFirstTimeLaunch
    }
    
    // Check if you are logged in
    func isLoggedIn() -> Bool {
        return !defaultStorage.loggedInUserIdKey
    }
}

extension SplashViewController{
  func updateLanguageIfNeeded() {
    guard defaultStorage.didLanguageSetup == false else { return }
    let langStr = Locale.current.languageCode
    switch langStr {
    case "vi":
      defaultStorage.currentLanguage = "vi"
    default:
      defaultStorage.currentLanguage = "en"
    }
    defaultStorage.didLanguageSetup = true
  }
}
