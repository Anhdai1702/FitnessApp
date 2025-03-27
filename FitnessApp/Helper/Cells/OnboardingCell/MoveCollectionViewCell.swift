//
//  MoveCollectionViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 4/3/25.
//

import UIKit

class MoveCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var moveView: UIView!
    
    struct ConstantsDotNotNormal {
        static let selectedColor = UIColor(hex: "#896CFE")
        static let unselectedColor = UIColor(hex: "#FFFFFF")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateView(isSelect: Bool) {
        moveView.backgroundColor = isSelect ?  ConstantsDotNotNormal.unselectedColor: ConstantsDotNotNormal.selectedColor
    }

}
