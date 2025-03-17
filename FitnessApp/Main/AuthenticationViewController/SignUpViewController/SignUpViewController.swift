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
    
    @IBOutlet private weak var createAccountLabel: UILabel!
    @IBOutlet private weak var startLabel: UILabel!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var emailAndMobileLabel: UILabel!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var confirmPasswordLabel: UILabel!
    @IBOutlet private weak var termsOfUseLabel: UILabel!
    @IBOutlet private weak var orSignUpLabel: UILabel!
    @IBOutlet private weak var loginLabel: UILabel!
    
    @IBOutlet private weak var fullNameTextField: UITextField!
    @IBOutlet private weak var emailAndNumberTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet private weak var signUpBtn: UIButton!

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
        setupLocalized()
        setupLoginLabel()
        setupDismissKeyboard()
    }
    
    private func setupLocalized() {
        createAccountLabel.text = "create_account".localized()
        startLabel.text = "start".localized()
        fullNameLabel.text = "full_name".localized()
        emailAndMobileLabel.text = "email".localized()
        passwordLabel.text = "password".localized()
        confirmPasswordLabel.text = "confirm_password".localized()
        loginLabel.text = "login_prompt".localized()
        // add placeholder 
        fullNameTextField.placeholder = "full_name".localized()
        emailAndNumberTextField.placeholder = "email_or_phone".localized()
        passwordTextField.placeholder = "enter_password".localized()
        confirmPasswordTextField.placeholder = "confirm_password".localized()
    }
    
    private func setupDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupLabelStyle() {
        let text1 = "terms_of_use_prefix".localized()
        let terms = "terms_of_use".localized()
        let and = "and".localized()
        let privacy = "privacy_policy".localized()
        
        let fullText = NSMutableAttributedString(string: text1, attributes: [
            .foregroundColor: UIColor.systemGray5,
            .font: UIFont.systemFont(ofSize: 12)
        ])
        
        let termsAttr = NSAttributedString(string: terms, attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 12)
        ])
        
        let andAttr = NSAttributedString(string: and, attributes: [
            .foregroundColor: UIColor.systemGray5,
            .font: UIFont.systemFont(ofSize: 12)
        ])
        
        let privacyAttr = NSAttributedString(string: privacy, attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 12)
        ])
        
        fullText.append(termsAttr)
        fullText.append(andAttr)
        fullText.append(privacyAttr)
        
        termsOfUseLabel.attributedText = fullText
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        termsOfUseLabel.isUserInteractionEnabled = true
        termsOfUseLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setupLoginLabel() {
        let textOne = "already_have_an_account".localized()
        let termTwo = "login_account".localized()
        let fullText = NSMutableAttributedString(string: textOne, attributes: [
            .foregroundColor: UIColor.systemGray5,
            .font: UIFont.systemFont(ofSize: 12)
        ])
        
        let termsAttr = NSAttributedString(string: termTwo, attributes: [
            .foregroundColor: UIColor(resource: .lightGreen),
            .font: UIFont.systemFont(ofSize: 12)
        ])
        
        fullText.append(termsAttr)
        
        loginLabel.attributedText = fullText
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func loginTapped() {
        self.navigationController?.popViewController(animated: true)
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
        
        if (text as NSString).range(of: "terms_of_use".localized()).contains(index) {
            //            push(viewControllerType: TermsOfUseViewController.self)
        } else if (text as NSString).range(of: "privacy_policy".localized()).contains(index) {
            //            push(viewControllerType: PrivacyPolicyViewController.self)
        }
    }
    
    private func signUp() {
        
        guard let fullName = fullNameTextField.text, let emailAndNumber = emailAndNumberTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else {
            return
        }
        if fullName.isEmpty || emailAndNumber.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showAlert(title: "error".localized(), mess: "all_fields_required".localized())
            return
        }
        if fullName.count < 3 {
            showAlert(title: "error".localized(), mess: "full_name_min_length".localized())
            return
        }
        if emailAndNumber.validateEmailOrPhone() == false || emailAndNumber.count < 8 {
            showAlert(title: "error".localized(), mess: "invalid_email_or_phone".localized())
            return
        }
        if password.count < 6 {
            showAlert(title: "error".localized(), mess: "password_min_length".localized())
            return
        }
        if password != confirmPassword {
            showAlert(title: "error".localized(), mess: "password_not_match".localized())
            return
        }
        Auth.auth().createUser(withEmail: emailAndNumberTextField.text!, password: passwordTextField.text!) { result, error in
            self.hidesBottomBarWhenPushed = false
            self.showAlert(title: "congratulations".localized(), mess: "sign_up_successfully".localized())
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
                self.showAlert(title: "error".localized(), mess: "\(error.localizedDescription)")
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
                        self.showAlert(title: "notification".localized(), mess: "successfully".localized())
                    } else {
                        self.self .showAlert(title: "error".localized(), mess: "\(String(describing: error?.localizedDescription))")
                    }
                }
            }
        }
    }
}
