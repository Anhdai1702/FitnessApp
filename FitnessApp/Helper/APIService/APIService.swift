//
//  APIService.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 20/3/25.
//

import Foundation
import UIKit
import SDWebImage

// MARK: - Fitness Data Model
struct FitnessItem: Codable {
    let id: String
    let name: String
    let avatar: String
    let articles: String
    let recommendations: String
    let createdAt: String
    let weeklyChallenge: String
    let titleImageWorkout: String
    let timeWorkout: String
    let kcalWorkout: String
    let exercisesWorkout: String
    let tileWorkout: String
}

struct IndexFitness: Codable {
    let title: String
    let avatar: String
    let time: String
    let kcal: String
    let createdAt: String
    let id: String
    var isFavorite: Bool = false
    var titleHeaderImage: String
    var workoutContent: String
    var nutritionContent: String
    var exercises: String
    var titleHeader: String
    var isFavoriteHeader: Bool = false
    var category: String
    var titleImageWorkout: String
    var titleWorkout: String
    var timeWorkout: String
    var kcalWorkout: String
    var exercisesWorkout: String
    var favoriteWorkout: Bool = false
    var titleWorkoutTableViewImage: String
    var titleWorkoutTableViewLabel: String
    var timeWorkoutTableViewLabel: String
    var kcalWorkoutTableViewLabel: String
    var exercisesWorkoutTableViewLabel: String
    var favoriteWorkoutTableViewImage: Bool = false
}

struct listBeginner {
    var list: [IndexFitness]
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

class IndexFitnessApp {
    static let shared = IndexFitnessApp()
    private let baseURL = "https://67c5afd9351c081993fb04e9.mockapi.io/api/fitnessApp/searchApi"

    private init() {}

    // MARK: - Fetch Fitness Data
    func fetchFitnessData(completion: @escaping (Result<[IndexFitness], Error>) -> Void) {
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
                let fitnessData = try JSONDecoder().decode([IndexFitness].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(fitnessData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func updateFavoriteStatus(for item: IndexFitness, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(item.id)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["isFavorite": item.isFavorite]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }.resume()
    }
}

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        self.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground, .progressiveLoad])
    }
}

