//
//  ProfileSetupViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 8/3/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

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
    
    private var userListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
       }

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           userListener?.remove() // Dừng lắng nghe khi rời khỏi màn hình
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
        push(viewControllerType: TabBarViewController.self)
    }
}

// MARK: - Custom UI
extension ProfileSetupViewController {
    
    private func setupUI() {
        setupLocalized()
        setupDismissKeyboard()
        fetchUserData()
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
    
    @objc private func fetchUserData() {
        UserService.shared.fetchUserData { [weak self] data in
            guard let self = self, let data = data else {
                return
            }

            DispatchQueue.main.async {
                self.fullNameTextField.text = data["fullName"] as? String ?? ""
                self.emailTextField.text = data["emailAndNumber"] as? String ?? ""
                self.nickNameTextField.text = data["nickName"] as? String ?? ""
                self.mobileNumberTextField.text = data["mobileNumber"] as? String ?? ""
            }
        }
    }


}
