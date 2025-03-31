//
//  TitleNotificationsView.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 28/3/25.
//

import UIKit

class TitleNotificationsView: NibView {

    @IBOutlet weak var titleLabel: UILabel!
    
     let sectionTitles: [String] = [
        "Danh sách thông báo",
        "Thông báo quan trọng",
        "Thông báo hệ thống"
    ]

    
    override func configureView() {
        super.configureView()
    }
    
    func configure(with title: String) {
            titleLabel.text = title
        }
    
}
