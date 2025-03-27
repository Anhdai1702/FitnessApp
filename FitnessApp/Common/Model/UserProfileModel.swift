//
//  UserModel.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 18/3/25.
//

import Foundation
import UIKit
import RealmSwift


struct UserProfileModel {
    var selectUserImage: UIImage?
    var selectUserLabel: String
}


class UserProfile: Object {
    @Persisted var userId: String = ""
    @Persisted var profileImageData: Data? 

    override static func primaryKey() -> String? {
        return "userId"
    }
}


