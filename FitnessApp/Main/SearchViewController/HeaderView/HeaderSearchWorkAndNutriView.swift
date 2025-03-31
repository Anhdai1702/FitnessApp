//
//  HeaderSearchWorkAndNutriView.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 29/3/25.
//

import UIKit

class HeaderSearchWorkAndNutriView: NibView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func configureView() {
        super.configureView()
    }
    
    func configure(category: SearchCategory) {
        switch category {
        case .workout:
            titleLabel.text = "Workout"
        case .nutrition:
            titleLabel.text = "Nutrition"
        default:
            break
        }
    }
    
}
