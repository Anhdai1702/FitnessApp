//
//  BeginnerHeaderView.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 5/4/25.
//

import UIKit

class BeginnerHeaderView: NibView {
    
    @IBOutlet private weak var beginnerHeaderImage: UIImageView!
    
    var selectedWorkout: IndexFitness?
    
    override func configureView() {
        super.configureView()
        fetchDataWorkout()
    }
    
    func fetchDataWorkout() {
        guard let selectedWorkout = selectedWorkout else { return }
        beginnerHeaderImage.loadImage(from: selectedWorkout.titleWorkoutTableViewImage)
    }
}
