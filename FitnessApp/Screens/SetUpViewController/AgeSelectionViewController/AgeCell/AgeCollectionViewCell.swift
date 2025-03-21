//
//  AgeCollectionViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 10/3/25.
//

import UIKit

class AgeCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var contenView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(age: Int, isCentered: Bool, borderWith: Bool) {
        ageLabel.text = "\(age)"
        ageLabel.textColor = isCentered ? .white : .darkGray
        ageLabel.font = isCentered ? UIFont.boldSystemFont(ofSize: 40) : UIFont.systemFont(ofSize: 30)
        contenView.layer.borderWidth = borderWith ? 1 : 0
    }
}
