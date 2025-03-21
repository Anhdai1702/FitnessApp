//
//  PhysicalActivityViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 14/3/25.
//

import UIKit

private enum Physical {
    case beginner
    case intermediate
    case advance
}

class PhysicalActivityViewController: UIViewController {
    
    @IBOutlet private weak var backLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var beginnerLabel: UILabel!
    @IBOutlet private weak var intermediateLabel: UILabel!
    @IBOutlet private weak var advanceLabel: UILabel!
    
    @IBOutlet private weak var beginnerView: UIView!
    @IBOutlet private weak var intermediateView: UIView!
    @IBOutlet private weak var advanceView: UIView!
    
    @IBOutlet private weak var nextBtn: UIButton!
    
    private var selectedPhysical: Physical?
    private let physicalLevels: [Physical] = [.beginner, .intermediate, .advance]
    
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
extension PhysicalActivityViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapBeginner(_ sender: Any) {
        selectedPhysical = .beginner
        setupSelection()
    }
    
    @IBAction func didTapIntermediate(_ sender: Any) {
        selectedPhysical = .intermediate
        setupSelection()
    }
    
    @IBAction func didTapAdvance(_ sender: Any) {
        selectedPhysical = .advance
        setupSelection()
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        guard let _ = selectedPhysical else {
            showAlert(title: "error".localized(), mess: "not_selected".localized())
            return }
        push(viewControllerType: ProfileSetupViewController.self)
    }
}

// MARK: - Custom UI
extension PhysicalActivityViewController {
    
    private func setupUI() {
        setupLocalized()
        setupSelection()
    }
    
    private func setupLocalized() {
        backLabel.text = "back".localized()
        questionLabel.text = "physical_question".localized()
        detailLabel.text = "detail_introduce".localized()
        beginnerLabel.text = "beginner".localized()
        intermediateLabel.text = "intermediate".localized()
        advanceLabel.text = "advance".localized()
        nextBtn.setTitle("next".localized(), for: .normal)
    }
    
    private func setupSelection() {
        let views = [beginnerView, intermediateView, advanceView]
        let labels = [beginnerLabel, intermediateLabel, advanceLabel]
        
        for (index, view) in views.enumerated() {
            let selectecd = selectedPhysical == physicalLevels[index]
            view?.backgroundColor = selectecd ? .lightGreen : .white
            labels[index]?.textColor = selectecd ? .black : .lightPurple
        }
    }
}
