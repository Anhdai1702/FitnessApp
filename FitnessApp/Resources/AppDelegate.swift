//
//  AppDelegate.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 3/3/25.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FBSDKCoreKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        FirebaseApp.configure()
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: "325587216029-v1j2lagh0mo6f07p8eashuu5gn2fgd47.apps.googleusercontent.com")
        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}
