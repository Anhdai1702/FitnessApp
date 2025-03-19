//
//  UserService.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 18/3/25.
//

import FirebaseAuth
import FirebaseFirestore

class UserService {
    static let shared = UserService()
    private init() {}

    private let db = Firestore.firestore()

    func fetchUserData(completion: @escaping ([String: Any]?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }

        let userId = user.uid
        let userRef = db.collection("users").document(userId)

        userRef.addSnapshotListener { document, error in
            guard let document = document, document.exists, let data = document.data() else {
                completion(nil)
                return
            }

            let authFullName = user.displayName ?? ""
            let authEmail = user.email ?? ""

            var updateData: [String: Any] = [:]

            if let storedEmail = data["emailAndNumber"] as? String, storedEmail != authEmail {
                updateData["emailAndNumber"] = authEmail
            }

            if let storedFullName = data["fullName"] as? String, storedFullName.isEmpty || storedFullName != authFullName {
                updateData["fullName"] = authFullName
            }

            if !updateData.isEmpty {
                userRef.updateData(updateData)
            }

            completion(data)
        }
    }
}

