//
//  TitleSectionHeaderView.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 5/4/25.
//

import UIKit

class TitleSectionHeaderView: NibView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func configureView() {
        super.configureView()
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
