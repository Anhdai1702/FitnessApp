//
//  BeginnerTableViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 5/4/25.
//

import UIKit

class BeginnerTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
}
