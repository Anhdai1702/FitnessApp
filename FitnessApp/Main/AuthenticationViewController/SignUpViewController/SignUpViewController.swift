//
//  SignUpViewController.swift
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

class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var fullNameTextField: UITextField!
    @IBOutlet private weak var emailAndNumberTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var termsOfUseLabel: UILabel!
    @IBOutlet private weak var loginLabel: UILabel!
    
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
extension SignUpViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        signUp()
    }
    
    @IBAction func didTapSignUpGoogle(_ sender: Any) {
        sginUpGoogle()
    }
    
    @IBAction func didTapSignUpFacebook(_ sender: Any) {
        signUpFacebook()
    }
    
    @IBAction func didTapSignUpFingerprint(_ sender: Any) {
        signUpFaceId()
    }
}

// MARK: - Custom methods
extension SignUpViewController {
    
    private func setupUI() {
        setupLabelStyle()
    }
    
    private func setupLabelStyle() {
        let text1 = "By continuing, you agree to\n"
        let terms = "Terms of Use"
        let and = " and "
        let privacy = "Privacy Policy."
        
        let fullText = NSMutableAttributedString(string: text1, attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 14)
        ])
        
        let termsAttr = NSAttributedString(string: terms, attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 14)
        ])
        
        let andAttr = NSAttributedString(string: and, attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 14)
        ])
        
        let privacyAttr = NSAttributedString(string: privacy, attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 14)
        ])
        
        fullText.append(termsAttr)
        fullText.append(andAttr)
        fullText.append(privacyAttr)
        
        termsOfUseLabel.attributedText = fullText
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        termsOfUseLabel.isUserInteractionEnabled = true
        termsOfUseLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func labelTapped(_ gesture: UITapGestureRecognizer) {
        let text = termsOfUseLabel.text ?? ""
        let tapLocation = gesture.location(in: termsOfUseLabel)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: termsOfUseLabel.bounds.size)
        let textStorage = NSTextStorage(attributedString: termsOfUseLabel.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let index = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if (text as NSString).range(of: "Terms of Use").contains(index) {
            //            push(viewControllerType: TermsOfUseViewController.self)
        } else if (text as NSString).range(of: "Privacy Policy").contains(index) {
            //            push(viewControllerType: PrivacyPolicyViewController.self)
        }
    }
    
    private func signUp() {
        
        guard let fullName = fullNameTextField.text, let emailAndNumber = emailAndNumberTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else {
            return
        }
        if fullName.isEmpty || emailAndNumber.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showAlert(title: "Error", mess: "All fields are required")
            return
        }
        if fullName.count < 3 {
            showAlert(title: "Error", mess: "Full name must be at least 3 characters long")
            return
        }
        if emailAndNumber.validateEmailOrPhone() == false || emailAndNumber.count < 8 {
            showAlert(title: "Error", mess: "Email or Phone is invalid")
            return
        }
        if password.count < 6 {
            showAlert(title: "Error", mess: "Password must be at least 6 characters long")
            return
        }
        if password != confirmPassword {
            showAlert(title: "Error", mess: "Password not match")
            return
        }
        Auth.auth().createUser(withEmail: emailAndNumberTextField.text!, password: passwordTextField.text!) { result, error in
            self.hidesBottomBarWhenPushed = false
            self.showAlert(title: "Congratulations", mess: "sign up successfully")
        }
    }
    
    // sign up google
    private func sginUpGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard let result = signInResult else { return }
            let user = result.user
            let id = user.userID
            let name = user.profile?.name
            let email = user.profile?.email
            self.push(viewControllerType: HomeViewController.self)
        }
    }
    
    // sign up facebook
    private func heckCurrentLoginStatus() {
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
    }
    
    private func signUpFacebook() {
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { result, error in
            if let error = error {
                self.showAlert(title: "Error", mess: "\(error.localizedDescription)")
            } else {
                print("next viewController")
            }
        }
    }
    
    // sign up FaceID
    private func signUpFaceId() {
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
