//
//  WorkoutMainContentCollectionViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 3/4/25.
//

import UIKit

protocol WorkoutMainContentCollectionViewCellDelegate: AnyObject {
    func didTapFavoriteWorkout(in cell: WorkoutMainContentCollectionViewCell)
}

class WorkoutMainContentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeWorkoutLabel: UILabel!
    @IBOutlet weak var kcalWorkoutLabel: UILabel!
    @IBOutlet weak var exercisesWorkoutLabel: UILabel!
    @IBOutlet weak var favoriteWorkoutImage: UIImageView!
    
    weak var delegate: WorkoutMainContentCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func didTapFavoriteWorkout(_ sender: Any) {
        self.delegate?.didTapFavoriteWorkout(in: self)
    }
    
    func configureWorkout(model: IndexFitness) {
        titleImage.loadImage(from: model.titleImageWorkout)
        titleLabel.text = model.titleWorkout
        timeWorkoutLabel.text = model.timeWorkout
        kcalWorkoutLabel.text = model.kcalWorkout
        exercisesWorkoutLabel.text = model.exercisesWorkout
        selectFavoriteWorkout(isSelect: model.favoriteWorkout)
    }
    
    func selectFavoriteWorkout(isSelect: Bool) {
        favoriteWorkoutImage.image = isSelect ? UIImage(resource: .starOn) : UIImage(resource: .starOff)
    }
}
