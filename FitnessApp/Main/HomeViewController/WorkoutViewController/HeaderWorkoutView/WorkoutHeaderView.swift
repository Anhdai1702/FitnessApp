//
//  WorkoutHeaderView.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 4/4/25.
//

import UIKit
import FirebaseDatabase

protocol WorkoutHeaderViewDelegate: AnyObject {
    func workoutHeaderView(_ header: WorkoutHeaderView, didSelectWorkout workout: IndexFitness)
}

class WorkoutHeaderView: NibView {
    
    @IBOutlet private weak var workoutHeaderCollectionView: UICollectionView!
    
    private var indexFitnessItems : [IndexFitness] = []
    var onSelectWorkout: ((IndexFitness) -> Void)?
    
    private var autoScrollTimer: Timer?
    private var currentIndex = 0
    
    weak var delegate: WorkoutHeaderViewDelegate?
    
    override func configureView() {
        super.configureView()
        setupUI()
    }
}

extension WorkoutHeaderView {
    
    private func setupUI() {
        setupCollectionView()
        fetchData()
        startAutoScroll()
    }
    
    private func setupCollectionView() {
        workoutHeaderCollectionView.register(UINib(nibName: "WorkoutMainContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WorkoutMainContentCollectionViewCell")
        workoutHeaderCollectionView.dataSource = self
        workoutHeaderCollectionView.delegate = self
    }
    
    private func startAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    @objc private func autoScroll() {
        guard !indexFitnessItems.isEmpty else { return }
        
        currentIndex = (currentIndex + 1) % indexFitnessItems.count
        let indexPath = IndexPath(item: currentIndex, section: 0)
        workoutHeaderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    private func fetchData() {
        IndexFitnessApp.shared.fetchFitnessData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.indexFitnessItems = data
                self.workoutHeaderCollectionView.reloadData()
            case .failure(_): break
            }
        }
    }
}

// MARK: - CollectionView: Datasource, Delegate, DelegateFlowLayout
extension WorkoutHeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexFitnessItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutMainContentCollectionViewCell", for: indexPath) as? WorkoutMainContentCollectionViewCell else {return UICollectionViewCell()}
        cell.configureWorkout(model: indexFitnessItems[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = indexFitnessItems[indexPath.row]
        self.delegate?.workoutHeaderView(self, didSelectWorkout: selected)
    }
}

extension WorkoutHeaderView: WorkoutMainContentCollectionViewCellDelegate {
    
    func didTapFavoriteWorkout(in cell: WorkoutMainContentCollectionViewCell) {
        guard let indexPath = workoutHeaderCollectionView.indexPath(for: cell) else {  return }
        let itemId = indexFitnessItems[indexPath.row].id
        if let indexInFullData = indexFitnessItems.firstIndex(where: { $0.id == itemId }) {
            indexFitnessItems[indexInFullData].favoriteWorkout.toggle()
        }
        let isFavorite = indexFitnessItems[indexPath.row].favoriteWorkout
        let apiURL = "https://67c5afd9351c081993fb04e9.mockapi.io/api/fitnessApp/searchApi/\(itemId)"
        var request = URLRequest(url: URL(string: apiURL)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["favoriteWorkout": isFavorite], options: [])
        URLSession.shared.dataTask(with: request).resume()
        Database.database().reference().child("favorites").child(itemId).setValue(["favoriteWorkout": isFavorite])
        cell.selectFavoriteWorkout(isSelect: isFavorite)
    }
}
