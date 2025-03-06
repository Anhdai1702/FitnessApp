//
//  LoginViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 3/3/25.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import LocalAuthentication


class LoginViewController: UIViewController {
    // outlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var noAccountLabel: UILabel!
    @IBOutlet private weak var logInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - Actions
extension LoginViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true )
    }
    
    @IBAction func didTapForgotPassword(_ sender: Any) {
        push(viewControllerType: ForgetPasswordViewController.self)
    }
    
    @IBAction func didTapLogIn(_ sender: Any) {
        checkEmailAndPasswordValidity()
    }
    
    @IBAction func didTapSignInGoogle(_ sender: Any) {
        loginGoogle()
    }
    
    @IBAction func didTapSignInFacebook(_ sender: Any) {
        loginFacebook()
    }
    
    @IBAction func didTapFingerprint(_ sender: Any) {
        loginFaceId()
    }
}

// MARK: - Custom methods
extension LoginViewController {
    
    
    // setup UI
    private func setupUI() {
        setupLabelStyle()
        setupDismissKeyboard()
    }
    private func setupDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupLabelStyle() {
        noAccountLabel.isUserInteractionEnabled = true
        let text = "Don’t have an account? "
        let signUpText = "Sign Up"
        let fullText = NSMutableAttributedString(string: text, attributes: [.foregroundColor: UIColor.black])
        let signUpAttr = NSMutableAttributedString(string: signUpText, attributes: [
            .foregroundColor: UIColor(resource: .lightGreen),
            .font: UIFont.boldSystemFont(ofSize: 12)
        ])
        
        fullText.append(signUpAttr)
        noAccountLabel.attributedText = fullText
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpTapped))
        noAccountLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func signUpTapped() {
        push(viewControllerType: SignUpViewController.self)
    }
    
    // log in email and password
    func checkEmailAndPasswordValidity() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Notification", mess: "No account or password entered")
            return
        }
        loginEmailAndPassword()
    }
    
    private func loginEmailAndPassword() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
            if let error = error {
                self.showAlert(title: "Error", mess: "\(error.localizedDescription)")
            } else {
                print("1")
            }
        }
    }
    
    // log in google
    private func loginGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard let result = signInResult else { return }
            let user = result.user
            let id = user.userID
            let name = user.profile?.name
            let email = user.profile?.email
            self.push(viewControllerType: HomeViewController.self)
        }
    }
    
    // log in facebook
    private func heckCurrentLoginStatus() {
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
    }
    
    private func loginFacebook() {
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { result, error in
            if let error = error {
                self.showAlert(title: "Error", mess: "\(error.localizedDescription)")
            } else {
                print("next viewController")
            }
        }
    }
    
    // log in FaceID
    private func loginFaceId() {
        let context = LAContext()
        var error:NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Scan your fingerprint to continue"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.showAlert(title: "Notification", mess: "Successfully")
                    } else {
                        self.self .showAlert(title: "Error", mess: "\(String(describing: error?.localizedDescription))")
                    }
                }
            }
        }
    }
}
