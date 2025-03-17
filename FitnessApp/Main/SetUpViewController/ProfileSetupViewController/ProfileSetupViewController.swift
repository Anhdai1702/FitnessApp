//
//  ProfileSetupViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 8/3/25.
//

import UIKit

class ProfileSetupViewController: UIViewController {
    
    @IBOutlet private weak var backLabel: UILabel!
    @IBOutlet private weak var yourProfileLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var nickNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var mobileNumberLabel: UILabel!
    
    @IBOutlet private weak var fullNameTextField: UITextField!
    @IBOutlet private weak var nickNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var mobileNumberTextField: UITextField!

    @IBOutlet private weak var imageProfile: UIImageView!
    @IBOutlet private weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Actions
extension ProfileSetupViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapChangeImageProfile(_ sender: Any) {
    }
    
    @IBAction func didTapStart(_ sender: Any) {
        push(viewControllerType: HomeViewController.self)
    }
}

// MARK: - Custom UI
extension ProfileSetupViewController {
    
    private func setupUI() {
        setupLocalized()
        setupDismissKeyboard()
    }
    
    private func setupLocalized() {
        backLabel.text = "back".localized()
        yourProfileLabel.text = "your_profile".localized()
        detailLabel.text = "detail_introduce".localized()
        fullNameLabel.text = "full_name".localized()
        nickNameLabel.text = "nick_name".localized()
        emailLabel.text = "email".localized()
        mobileNumberLabel.text = "mobile_number".localized()
        startBtn.setTitle("start_app".localized(), for: .normal)
    }
    
    private func setupDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
