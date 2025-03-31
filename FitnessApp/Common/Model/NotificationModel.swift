//
//  NotificationModel.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 27/3/25.
//

import Foundation
import UIKit

struct NotificationModel {
    var notificationFormImage: UIImage
    var notificationDetailsLabel: String
    var dateAndTimeOfAnnouncementLabel: String
}

enum NotificationSection: Int, CaseIterable {
    case notificationToday
    case notificationYesterday
    case notificationOthers

    var title: String {
        switch self {
        case .notificationToday: return "today".localized()
        case .notificationYesterday: return "yesterday".localized()
        case .notificationOthers: return "notificationOthers".localized()
        }
    }
}

enum NotificationType: CaseIterable {
    case today
    case yesterday
    case notificationOthers
    
    var items: [NotificationModel] {
        switch self {
        case .today:
            return setupNotification (
                [(.component40,"New workout is Available","June 10 - 10:00 AM"),
                 (.component40,"New workout is Available","June 10 - 10:00 AM"),
                 (.component40,"New workout is Available","June 10 - 10:00 AM")
                ])
        case .yesterday:
            return setupNotification(
                [(.component40,"New workout is Available","June 10 - 10:00 AM"),
                 (.component40,"New workout is Available","June 10 - 10:00 AM")
                ])
        case .notificationOthers:
            return setupNotification(
                [(.component40,"New workout is Available","June 10 - 10:00 AM")
                ])
        }
    }
}

private func setupNotification(_ setup: [(UIImage, String, String)]) -> [NotificationModel] {
    return setup.map { NotificationModel(notificationFormImage: $0.0, notificationDetailsLabel: $0.1, dateAndTimeOfAnnouncementLabel: $0.2) }
}
   
