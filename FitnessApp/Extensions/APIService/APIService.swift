//
//  APIService.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 20/3/25.
//

import Foundation
import UIKit

// MARK: - Fitness Data Model
struct FitnessItem: Codable {
    let id: String
    let name: String
    let avatar: String
    let articles: String
    let recommendations: String
    let createdAt: String
    let weeklyChallenge: String
}


class FitnessAPIService {
    static let shared = FitnessAPIService() // Singleton
    private let baseURL = "https://67c5afd9351c081993fb04e9.mockapi.io/api/fitnessApp/fitnessApp"

    private init() {}

    // MARK: - Fetch Fitness Data
    func fetchFitnessData(completion: @escaping (Result<[FitnessItem], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 404, userInfo: nil)))
                return
            }

            do {
                let fitnessData = try JSONDecoder().decode([FitnessItem].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(fitnessData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

