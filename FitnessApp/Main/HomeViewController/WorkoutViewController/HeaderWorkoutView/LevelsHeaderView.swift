//
//  LevelsHeaderView.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 8/4/25.
//

import UIKit

protocol LevelsHeaderViewDelegate: AnyObject {
    func didTapBeginner()
    func didTapIntermediate()
    func didTapAdvanced()
}

class LevelsHeaderView: NibView {
    
    
    @IBOutlet private weak var beginnerLabel: UILabel!
    @IBOutlet private weak var intermediate: UILabel!
    @IBOutlet private weak var advancedLabel: UILabel!
    @IBOutlet private weak var beginnerView: UIView!
    @IBOutlet private weak var intermediateView: UIView!
    @IBOutlet private weak var advancedView: UIView!
    
    private var labels: [UILabel] {
        return [beginnerLabel, intermediate, advancedLabel]
    }
    
    private var titleLabel: [String] {
        return ["Beginner", "Intermediate", "Advanced"]
    }
    
    private var levelsView: [UIView] {
        return [beginnerView, intermediateView, advancedView]
    }
    
    weak var delegate: LevelsHeaderViewDelegate?
    
    override func configureView() {
        super.configureView()
        setupSelectRegime(section: 0)
    }
    
    @IBAction func didTapBeginner(_ sender: Any) {
        self.delegate?.didTapBeginner()
        setupSelectRegime(section: 0)
    }
    
    @IBAction func didTapIntermediate(_ sender: Any) {
        self.delegate?.didTapIntermediate()
        setupSelectRegime(section: 1)
    }
    
    @IBAction func didTapAdvanced(_ sender: Any) {
        self.delegate?.didTapAdvanced()
        setupSelectRegime(section: 2)
    }
    
    private func setupSelectRegime(section: Int) {
        
        for (index, label) in labels.enumerated() {
            label.text = titleLabel[index]
            label.textColor = (index == section) ? UIColor.black : UIColor(resource: .lightPurple)
        }
        
        for (index, uiview) in levelsView.enumerated() {
            uiview.backgroundColor = (index == section) ? UIColor(resource: .lightGreen) : UIColor.white
        }
    }
}
