//
//  NotificationsTableViewCell.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 27/3/25.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet private weak var notificationFormImage: UIImageView!
    @IBOutlet private weak var notificationDetailsLabel: UILabel!
    @IBOutlet private weak var dateAndTimeOfAnnouncementLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    func configure(model: NotificationModel) {
        notificationFormImage.image = model.notificationFormImage
        notificationDetailsLabel.text = model.notificationDetailsLabel
        dateAndTimeOfAnnouncementLabel.text = model.dateAndTimeOfAnnouncementLabel
    }
}
