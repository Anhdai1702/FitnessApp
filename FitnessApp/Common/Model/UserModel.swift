//
//  UserModel.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 18/3/25.
//

import RealmSwift

class UserModel: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var fullName: String
    @Persisted var emailAndNumber: String
    @Persisted var createdAt: Date
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func saveUserToRealm(userId: String, fullName: String, emailAndNumber: String) -> Bool {
        guard !userId.isEmpty else {
            return false
        }
        
        do {
            let realm = try Realm()
            let user = UserModel()
            user.id = userId
            user.fullName = fullName
            user.emailAndNumber = emailAndNumber
            user.createdAt = Date()
            
            try realm.write {
                realm.add(user, update: .modified)
            }
            return true
        } catch {
            return false
        }
    }
}
