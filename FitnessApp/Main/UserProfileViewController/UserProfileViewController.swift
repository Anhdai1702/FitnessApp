//
//  UserProfileViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 20/3/25.
//

import UIKit
import FirebaseAuth
import RealmSwift
import FirebaseFirestore

class UserProfileViewController: UIViewController {
    
    // personal information
    @IBOutlet private weak var myProfileLabel: UILabel!
    @IBOutlet private weak var avatarUserImage: UIImageView!
    @IBOutlet private weak var editProfileImage: UIImageView!
    @IBOutlet private weak var nameUserLabel: UILabel!
    @IBOutlet private weak var emailUserLabel: UILabel!
    @IBOutlet private weak var birthdayUserLabel: UILabel!
    @IBOutlet private weak var userWeightLabel: UILabel!
    @IBOutlet private weak var unitWeightLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var userAgeLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var userHeightLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!
    
    // edit information
    @IBOutlet private weak var editFullNameLabel: UILabel!
    @IBOutlet private weak var editEmailLabel: UILabel!
    @IBOutlet private weak var editMobileNumberLabel: UILabel!
    @IBOutlet private weak var editDateOfBirthLabel: UILabel!
    @IBOutlet private weak var editWeightLabel: UILabel!
    @IBOutlet private weak var editHeightLabel: UILabel!
    
    @IBOutlet private weak var editFullNameTextField: UITextField!
    @IBOutlet private weak var editEmailTextField: UITextField!
    @IBOutlet private weak var editMobileNumberTextField: UITextField!
    @IBOutlet private weak var editDateOfBirthTextField: UITextField!
    @IBOutlet private weak var editWeightTextField: UITextField!
    @IBOutlet private weak var editHeightTextField: UITextField!
    
    @IBOutlet private weak var userProfileTableView: UITableView!
    @IBOutlet private weak var userInformationView: UIView!
    
    @IBOutlet weak var updateProfileBtn: UIButton!
    
    private let db = Firestore.firestore()
    
    private let userModel = [UserProfileModel(selectUserImage: .component39, selectUserLabel: "Profile"),
                             UserProfileModel(selectUserImage: .component40, selectUserLabel: "Favorite"),
                             UserProfileModel(selectUserImage: .component41, selectUserLabel: "Policy"),
                             UserProfileModel(selectUserImage: .component42, selectUserLabel: "Settings"),
                             UserProfileModel(selectUserImage: .component43, selectUserLabel: "Help"),
                             UserProfileModel(selectUserImage: .component44, selectUserLabel: "Logout")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchUserData()
        loadUserProfileImage()
    }
}

extension UserProfileViewController {
    
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func didTapEditProfile(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func didTapUpdateProfile(_ sender: Any) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
            
            let updatedData: [String: Any] = [
                "fullName": editFullNameTextField.text ?? "",
                "emailAndNumber": editEmailTextField.text ?? "",
                "weight": Int(editWeightTextField.text ?? "") ?? 0,
                "height": Int(editHeightTextField.text ?? "") ?? 0,
                "mobilePhone": Int(editMobileNumberLabel.text ?? "") ?? 0,
                "dateOfBirth": editDateOfBirthTextField.text ?? ""
            ]
            
            UserService.shared.updateUserData(userId: userId, userData: updatedData) { success, error in
                if success {
                    self.fetchUserData()
                    NotificationCenter.default.post(name: NSNotification.Name("UserProfileUpdated"), object: nil)
                }
            }
    }
}

// MARK: Custom UI
extension UserProfileViewController {
    
    private func setupUI() {
        setupLocalized()
        setupTableView()
        setupAvatarUser()
        selectIsHidden(true)
    }
    
    private func setupLocalized() {
        myProfileLabel.text = "my_profile".localized()
        weightLabel.text = "weight".localized()
        ageLabel.text = "age".localized()
        heightLabel.text = "height".localized()
        updateProfileBtn.setTitle("update_profile".localized(), for: .normal)
        editFullNameLabel.text = "edit_full_name".localized()
        editEmailLabel.text = "edit_email".localized()
        editMobileNumberLabel.text = "edit_mobile_number".localized()
        editDateOfBirthLabel.text = "edit_date_of_birth".localized()
        editWeightLabel.text = "edit_weight".localized()
        editHeightLabel.text = "edit_height".localized()
        updateProfileBtn.setTitle("update_profile".localized(), for: .normal)
    }
    
    private func setupAvatarUser() {
        avatarUserImage.layer.cornerRadius = avatarUserImage.frame.width / 2
        avatarUserImage.clipsToBounds = true
    }
    
    private func setupTableView() {
        userProfileTableView.dataSource = self
        userProfileTableView.delegate = self
        userProfileTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
    }
    
    @objc private func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let userRef = Firestore.firestore().collection("users").document(userId)

        // Lấy dữ liệu từ SERVER, không dùng cache
        userRef.getDocument(source: .server) { document, error in
            if let error = error { return }
            if let data = document?.data() {
                DispatchQueue.main.async {
                    self.nameUserLabel.text = data["fullName"] as? String ?? "N/A"
                    self.emailUserLabel.text = data["emailAndNumber"] as? String ?? "N/A"
                    self.editFullNameTextField.text = data["fullName"] as? String ?? ""
                    self.editEmailTextField.text = data["emailAndNumber"] as? String ?? ""
                    self.userAgeLabel.text = "\(data["age"] as? Int ?? 0) tuổi"

                    if let weight = data["weight"] as? Int {
                        self.userWeightLabel.text = "\(weight) kg"
                        self.editWeightTextField.text = "\(weight)"
                    }
                    if let height = data["height"] as? Int {
                        self.userHeightLabel.text = "\(height) cm"
                        self.editHeightTextField.text = "\(height)"
                    }
                }
            }
        }
    }

    
    private func selectIsHidden(_ isHidden: Bool) {
        userInformationView.isHidden = isHidden
        userProfileTableView.isHidden = !isHidden
        editProfileImage.isHidden = isHidden
        updateProfileBtn.isHidden = isHidden
    }
    
    private func performLogout() {
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            
            // Thêm hiệu ứng pop từ trái sang phải
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .push
            transition.subtype = .fromLeft
            view.window?.layer.add(transition, forKey: kCATransition)
            
            view.window?.rootViewController = navController
            view.window?.makeKeyAndVisible()
        }
}

// MARK: -
extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: userModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = userModel[indexPath.row].selectUserLabel
        switch selectedItem {
        case "Profile":
            selectIsHidden(false)
        case "Favorite":
            push(viewControllerType: FavoriteViewController.self)
        case "Policy":
            break
        case "Settings":
            push(viewControllerType: SettingViewController.self)
        case "Help":
            push(viewControllerType: SupportViewController.self)
        case "Logout":
            performLogout()
        default:
            break
        }
    }
}

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        avatarUserImage.image = selectedImage
        
        if let userId = Auth.auth().currentUser?.uid {
            saveProfileImage(selectedImage, for: userId)
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}


// MARK: - Firebase & Realm Data Handling
extension UserProfileViewController {
    
    func saveProfileImage(_ image: UIImage, for userId: String) {
        let realm = try! Realm()
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            try! realm.write {
                if let userProfile = realm.object(ofType: UserProfile.self, forPrimaryKey: userId) {
                    userProfile.profileImageData = imageData
                } else {
                    let newUserProfile = UserProfile()
                    newUserProfile.userId = userId
                    newUserProfile.profileImageData = imageData
                    realm.add(newUserProfile)
                }
            }
        }
    }
    
    func loadProfileImage(for userId: String) -> UIImage? {
        let realm = try! Realm()
        if let userProfile = realm.object(ofType: UserProfile.self, forPrimaryKey: userId),
           let imageData = userProfile.profileImageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    private func loadUserProfileImage() {
        if let userId = Auth.auth().currentUser?.uid, let savedImage = loadProfileImage(for: userId) {
            avatarUserImage.image = savedImage
        }
    }
}
