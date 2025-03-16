//
//  NumberCollectionViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 10/3/25.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with number: Int, isSelected: Bool) {
        numberLabel.text = "\(number)"
        numberLabel.textColor = isSelected ? .white : .darkGray
    }

}
