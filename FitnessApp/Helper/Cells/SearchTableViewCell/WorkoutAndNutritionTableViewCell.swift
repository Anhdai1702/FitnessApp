//
//  WorkoutAndNutritionTableViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 29/3/25.
//

import UIKit

protocol WorkoutAndNutrition: AnyObject {
    func didSelectWorkoutAndNutrition()
}

class WorkoutAndNutritionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var nutritionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    func configure(model: IndexFitness, category: SearchCategory) {
        workoutLabel.text = model.workoutContent
        nutritionLabel.text = model.nutritionContent
        switch category {
        case .workout:
            workoutLabel.isHidden = false
            nutritionLabel.isHidden = true
        case .nutrition:
            workoutLabel.isHidden = true
            nutritionLabel.isHidden = false
        default:
            break
        }
    }
}
