//
//  WorkoutTableViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 4/4/25.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleWorkoutTableViewImage: UIImageView!
    @IBOutlet private weak var favoriteWorkoutTableViewImage: UIImageView!
    @IBOutlet private weak var titleWorkoutTableViewLabel: UILabel!
    @IBOutlet private weak var timeWorkoutTableViewLabel: UILabel!
    @IBOutlet private weak var kcalWorkoutTableViewLabel: UILabel!
    @IBOutlet private weak var exercisesWorkoutTableViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        favoriteWorkoutTableViewImage.image = UIImage(resource: .starOff)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    func configure(model: IndexFitness) {
        titleWorkoutTableViewImage.loadImage(from: model.titleWorkoutTableViewImage)
        titleWorkoutTableViewLabel.text = model.titleWorkoutTableViewLabel
        timeWorkoutTableViewLabel.text = model.timeWorkoutTableViewLabel
        kcalWorkoutTableViewLabel.text = model.kcalWorkoutTableViewLabel
        exercisesWorkoutTableViewLabel.text = model.exercisesWorkoutTableViewLabel
        selectFavorite(isSelect: model.favoriteWorkoutTableViewImage)
    }
    
    func selectFavorite(isSelect: Bool) {
        favoriteWorkoutTableViewImage.image = isSelect ? UIImage(resource: .starOn) : UIImage(resource: .starOff)
    }
}
