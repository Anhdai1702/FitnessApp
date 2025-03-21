//
//  GenderViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 8/3/25.
//

import UIKit

enum Gender {
    case male
    case female
}

class GenderViewController: UIViewController {

    @IBOutlet private weak var backLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var maleLabel: UILabel!
    @IBOutlet private weak var femaleLabel: UILabel!
    
    @IBOutlet private weak var nextBtn: UIButton!
    
    @IBOutlet private weak var isChangeMaleImage: UIImageView!
    @IBOutlet private weak var isChangeFemeleImage: UIImageView!
    
    private var selectedGender: Gender?
    
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
extension GenderViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapChangeMale(_ sender: Any) {
        selectedGender = .male
        setupImage()
    }
    
    @IBAction func didTapChangeFemele(_ sender: Any) {
        selectedGender = .female
        setupImage()
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        guard let _ = selectedGender else {
            showAlert(title: "error".localized(), mess: "not_selected".localized())
            return
        }
        let vc = AgeSelectionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Custom UI
extension GenderViewController {
    
    private func setupUI() {
        setupImage()
        setupLocalized()
    }
    
    private func setupLocalized() {
        backLabel.text = "back".localized()
        maleLabel.text = "male".localized()
        femaleLabel.text = "female".localized()
        questionLabel.text = "gender_question".localized()
        detailLabel.text = "detail_introduce".localized()
        nextBtn.setTitle("next".localized(), for: .normal)
    }
    
    private func setupImage() {
        isChangeMaleImage.image = UIImage(named: selectedGender == .male ? "male_on" : "male_off")
        isChangeFemeleImage.image = UIImage(named: selectedGender == .female ? "female_on" : "female_off")
    }
}

