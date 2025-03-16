//
//  SelectHeightCollectionViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 14/3/25.
//

import UIKit

class SelectHeightCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var selectHeightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with number: Int, isSelected: Bool) {
        selectHeightLabel.text = "\(number)"
        selectHeightLabel.textColor = isSelected ? .white : .darkGray
        selectHeightLabel.font = isSelected ? .boldSystemFont(ofSize: 40) : .boldSystemFont(ofSize: 30)
    }
}
