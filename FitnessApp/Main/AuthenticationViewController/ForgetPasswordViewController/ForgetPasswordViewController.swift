//
//  ForgetPasswordViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 6/3/25.
//

import UIKit
import FirebaseAuth

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet private weak var forgetPasswordLabel: UILabel!
    @IBOutlet private weak var questionForgotPasswordLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - Action
extension ForgetPasswordViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        resetPassword()
    }
    
}

// MARK: - Custom UI
extension ForgetPasswordViewController {
    
    private func setupUI() {
        setupLocalized()
        setupDismissKeyboard()
    }
    
    private func setupLocalized() {
        forgetPasswordLabel.text = "forget_password_title".localized()
        questionForgotPasswordLabel.text = "forget_password_question".localized()
        detailLabel.text = "detail_introduce".localized()
        emailLabel.text = "enter_password".localized()
        continueBtn.setTitle("next".localized(), for: .normal)
        emailTextField.placeholder = "enter_password".localized()
    }
    
    private func setupDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func resetPassword() {
        guard let email = emailTextField.text else { return }
        if email.isEmpty {
            showAlert(title: "error".localized(), mess: "all_fields_required".localized())
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showAlert(title: "error".localized(), mess: error.localizedDescription)
            } else {
                self.showAlert(title: "successfully".localized(), mess: "password_reset_sent".localized())
            }
        }
    }
}
