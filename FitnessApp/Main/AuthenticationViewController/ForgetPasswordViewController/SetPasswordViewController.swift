//
//  SetPasswordViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 16/3/25.
//

import UIKit

class SetPasswordViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var comfirmPasswordLabel: UILabel!
    
    @IBOutlet private weak var enterPassword: UITextField!
    @IBOutlet private weak var enterComfirmPassword: UITextField!
    
    @IBOutlet private weak var finishBtn: UIButton!
    
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
extension SetPasswordViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
    }
    
    @IBAction func didTapFinish(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Custom UI
extension SetPasswordViewController {
    
    private func setupUI() {
        setupLocalized()
        setupDismissKeyboard()
    }
    
    private func setupDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupLocalized() {
        titleLabel.text = "set_password".localized()
        detailLabel.text = "detail_introduce".localized()
        passwordLabel.text = "password".localized()
        comfirmPasswordLabel.text = "confirm_password".localized()
        enterPassword.placeholder = "enter_password".localized()
        enterComfirmPassword.placeholder = "confirm_password".localized()
        finishBtn.setTitle("finish".localized(), for: .normal)
    }
}
