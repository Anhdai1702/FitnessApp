//
//  UserProfileViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 20/3/25.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet private weak var myProfileLabel: UILabel!
    @IBOutlet private weak var avatarUserImage: UIImageView!
    @IBOutlet private weak var nameUserLabel: UILabel!
    @IBOutlet private weak var emailUserLabel: UILabel!
    @IBOutlet private weak var birthdayUserLabel: UILabel!
    @IBOutlet private weak var userWeightLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var userAgeLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var userHeightLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!
    
    @IBOutlet private weak var userProfileTableView: UITableView!
    
    let tabbar = TabBarViewController()
    
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
    }
}

// MARK: Custom UI
extension UserProfileViewController {
    
    private func setupUI() {
        setupLocalized()
        setupTableView()
    }
    
    private func setupLocalized() {
        myProfileLabel.text = "my_profile".localized()
        weightLabel.text = "weight".localized()
        ageLabel.text = "age".localized()
        heightLabel.text = "height".localized()
    }
    
    private func setupTableView() {
        userProfileTableView.dataSource = self
        userProfileTableView.delegate = self
        userProfileTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
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
            self.navigationController?.popViewController(animated: true)
        case "Favorite":
            push(viewControllerType: FavoriteViewController.self)
        case "Policy":
            break
        case "Settings":
            push(viewControllerType: SettingViewController.self)
        case "Help":
            push(viewControllerType: SupportViewController.self)
        case "Logout":
            break
        default:
            break
        }
    }
}
