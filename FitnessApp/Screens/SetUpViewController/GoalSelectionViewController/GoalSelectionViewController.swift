//
//  GoalSelectionViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 14/3/25.
//

import UIKit

enum GoalType {
    case loseWeight
    case gainWeight
    case muscleMassGain
    case shapeBody
    case others
}

class GoalSelectionViewController: UIViewController {
    
    @IBOutlet private weak var backLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var loseWeightLabel: UILabel!
    @IBOutlet private weak var gainWeightLabel: UILabel!
    @IBOutlet private weak var muscleMassGainLabel: UILabel!
    @IBOutlet private weak var shapeBodyLabel: UILabel!
    @IBOutlet private weak var othersLabel: UILabel!
    
    @IBOutlet private weak var selectLoseWeightImage: UIImageView!
    @IBOutlet private weak var selectGainWeightImage: UIImageView!
    @IBOutlet private weak var selectMuscleMassGainImage: UIImageView!
    @IBOutlet private weak var selectShapeBodyImage: UIImageView!
    @IBOutlet private weak var selectOthersImage: UIImageView!
    
    @IBOutlet private weak var nextBtn: UIButton!
    
    private var selectedGoal: GoalType?

    
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
extension GoalSelectionViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapLoseWeight(_ sender: Any) {
        updateSelectedGoal(.loseWeight)
    }
    
    @IBAction func didTapGainWeight(_ sender: Any) {
        updateSelectedGoal(.gainWeight)
    }
    
    @IBAction func didTapMuscleMassGain(_ sender: Any) {
        updateSelectedGoal(.muscleMassGain)
    }
    
    @IBAction func didTapShapeBody(_ sender: Any) {
        updateSelectedGoal(.shapeBody)
    }
    
    @IBAction func didTapOthers(_ sender: Any) {
        updateSelectedGoal(.others)
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        guard let _ = selectedGoal else {
            showAlert(title: "error".localized(), mess: "not_selected".localized())
            return }
        push(viewControllerType: PhysicalActivityViewController.self)
    }
}

// MARK: - Custom UI
extension GoalSelectionViewController {
    
    private func setupUI() {
        setupLocalized()
        setupImage()
    }
    
    private func setupLocalized() {
        backLabel.text = "back".localized()
        questionLabel.text = "goal_question".localized()
        detailLabel.text = "detail_introduce".localized()
        loseWeightLabel.text = "lose_weight".localized()
        gainWeightLabel.text = "gain_weight".localized()
        muscleMassGainLabel.text = "muscle_mass_gain".localized()
        shapeBodyLabel.text = "shape_body".localized()
        othersLabel.text = "others".localized()
        nextBtn.setTitle("next".localized(), for: .normal)
    }
    
    private func setupImage() {
        let sharedImage = UIImage(resource: .check)
        selectLoseWeightImage.image = sharedImage
        selectGainWeightImage.image = sharedImage
        selectMuscleMassGainImage.image = sharedImage
        selectShapeBodyImage.image = sharedImage
        selectOthersImage.image = sharedImage
        updateSelectedGoal(nil)
    }
    
    private func updateSelectedGoal(_ goal: GoalType?) {
        selectedGoal = goal
        let goalImages = [selectLoseWeightImage, selectGainWeightImage, selectMuscleMassGainImage, selectShapeBodyImage, selectOthersImage]
        goalImages.forEach { $0?.isHidden = true }
        switch goal {
        case .loseWeight:
            selectLoseWeightImage.isHidden = false
        case .gainWeight:
            selectGainWeightImage.isHidden = false
        case .muscleMassGain:
            selectMuscleMassGainImage.isHidden = false
        case .shapeBody:
            selectShapeBodyImage.isHidden = false
        case .others:
            selectOthersImage.isHidden = false
        case .none:
            break
        }
    }
}
