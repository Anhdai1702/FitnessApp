//
//  UserTableViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 20/3/25.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet private weak var selectUserImage: UIImageView!
    @IBOutlet private weak var selectUserLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(with model: UserProfileModel ) {
        selectUserImage.image = model.selectUserImage
        selectUserLabel.text = model.selectUserLabel
    }
    
    
}
