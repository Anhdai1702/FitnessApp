import FirebaseAuth
import FirebaseFirestore

class UserService {
    static let shared = UserService()
    private init() {}

    private let db = Firestore.firestore()

    func fetchUserData(completion: @escaping ([String: Any]?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let userRef = db.collection("users").document(userId)
        let infoRef = db.collection("info").document(userId)

        let group = DispatchGroup()
        var userData: [String: Any] = [:]

        [userRef, infoRef].forEach { ref in
            group.enter()
            ref.getDocument { document, error in
                if let data = document?.data() {
                    userData.merge(data) { (_, new) in new }
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(userData.isEmpty ? nil : userData)
        }
    }

    func updateUserData(userId: String, userData: [String: Any], completion: @escaping (Bool, Error?) -> Void) {
        let userRef = db.collection("users").document(userId)
        let infoRef = db.collection("info").document(userId)

        let group = DispatchGroup()
        var lastError: Error?

        [userRef, infoRef].forEach { ref in
            group.enter()
            ref.updateData(userData) { error in
                if let error = error {
                    lastError = error
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(lastError == nil, lastError)
        }
    }
}
