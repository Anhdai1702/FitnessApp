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
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    // outlets
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var welcomeLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var orSignUpLabel: UILabel!
    
    @IBOutlet private weak var forgotPasswordBtn: UIButton!
    
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
    
    private func setupUI() {
        setupLabelStyle()
        setupDismissKeyboard()
        setupLocazied()
    }
    
    private func setupDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupLocazied() {
        loginLabel.text = "login_account".localized()
        welcomeLabel.text = "Welcome_back_to".localized()
        detailLabel.text = "detail_introduce".localized()
        usernameLabel.text = "email".localized()
        passwordLabel.text = "password".localized()
        orSignUpLabel.text = "sign_in_with".localized()
        forgotPasswordBtn.setTitle("forgot_password".localized(), for: .normal)
        logInBtn.setTitle("login_account".localized(), for: .normal)
        emailTextField.placeholder = "email_or_phone".localized()
        passwordTextField.placeholder = "enter_password".localized()
    }
    
    private func setupLabelStyle() {
        noAccountLabel.isUserInteractionEnabled = true
        let text = "no_account".localized()
        let signUpText = "sign_up".localized()
        let fullText = NSMutableAttributedString(string: text, attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 12)
        ])
        let signUpAttr = NSMutableAttributedString(string: signUpText, attributes: [
            .foregroundColor: UIColor(resource: .lightGreen),
            .font: UIFont.systemFont(ofSize: 12)
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
            showAlert(title: "notification".localized(), mess: "no_account_or_password".localized())
            return
        }
        loginEmailAndPassword()
    }
    
    private func loginEmailAndPassword() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.showAlert(title: "error".localized(), mess: "\(error.localizedDescription)")
                return
            }
            guard let user = result?.user else { return }
            let userId = user.uid
            let fullName = user.displayName ?? "Unknown"
            self.saveUserToFirestore(fullName: fullName, emailAndNumber: email, userId: userId)
            self.push(viewControllerType: TabBarViewController.self)
        }
    }

    // log in google
    private func loginGoogle() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard let result = signInResult else { return }
            let user = result.user
            let idToken = user.idToken?.tokenString  // Token Google
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken ?? "", accessToken: accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    return
                }
                // Get userId from Firebase Authentication
                guard let userId = authResult?.user.uid else { return }
                let fullName = user.profile?.name ?? "No Name"
                let email = user.profile?.email ?? "No Email"
                // save in Firestore
                self.saveUserToFirestore(fullName: fullName, emailAndNumber: email, userId: userId)
                self.push(viewControllerType: TabBarViewController.self)
            }
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
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { result, error in
            if let error = error {
                return
            }
            guard let token = AccessToken.current?.tokenString else {
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    return
                }
                // Get userId from Firebase Authentication
                guard let userId = authResult?.user.uid else { return }
                
                // Get user information from Facebook
                Profile.loadCurrentProfile { profile, error in
                    let fullName = profile?.name ?? "No Name"
                    let email = authResult?.user.email ?? "No Email"
                    // save in Firestore
                    self.saveUserToFirestore(fullName: fullName, emailAndNumber: email, userId: userId)
                    self.push(viewControllerType: TabBarViewController.self)
                }
            }
        }
    }
    
    // sign up FaceID
    private func loginFaceId() {
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
    
    // save information in FirebaseFirestore
    func saveUserToFirestore(fullName: String, emailAndNumber: String, userId: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)

        let userData: [String: Any] = [
            "fullName": fullName,
            "emailAndNumber": emailAndNumber,
            "createdAt": Timestamp(date: Date())
        ]
        userRef.setData(userData) { error in
            if let error = error {
                print("\(error.localizedDescription)")
            }
        }
    }
}
