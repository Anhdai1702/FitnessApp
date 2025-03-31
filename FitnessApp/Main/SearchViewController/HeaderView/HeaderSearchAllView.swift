//
//  HeaderSearchAllView.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 29/3/25.
//

import UIKit
import FirebaseDatabase

class HeaderSearchAllView: NibView {

    @IBOutlet private weak var headerSearchAllCollectionView: UICollectionView!
    private var indexFitnessApp = [IndexFitness]()
    private var filteredFitnessApp = [IndexFitness]()
        
    override func configureView() {
        super.configureView()
        setupUI()
    }
}

// MARK: - Custom UI
extension HeaderSearchAllView {
    
    private func setupUI() {
        setupCollectionView()
        fetchData()
    }
    
    private func fetchData() {
        IndexFitnessApp.shared.fetchFitnessData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.indexFitnessApp = data
                self.headerSearchAllCollectionView.reloadData()
                self.filterData(with: "")
            case .failure(_): break
            }
        }
    }
    
    func filterData(with keyword: String) {
        filteredFitnessApp = indexFitnessApp.filter { item in
            keyword.isEmpty || item.titleHeader.lowercased().contains(keyword.lowercased())
        }
        headerSearchAllCollectionView.reloadData()
    }
     
    private func setupCollectionView() {
        headerSearchAllCollectionView.register(UINib(nibName: "SearchAllCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchAllCollectionViewCell")
        headerSearchAllCollectionView.delegate = self
        headerSearchAllCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension HeaderSearchAllView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredFitnessApp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchAllCollectionViewCell", for: indexPath) as? SearchAllCollectionViewCell else
        { return UICollectionViewCell()}
        cell.configure(model: filteredFitnessApp[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 10) / 2, height: 138)
    }
}


extension HeaderSearchAllView: SearchAllCollectionViewCellDelegate {
    func didTapFavorite(cell: SearchAllCollectionViewCell) {
        guard let indexPath = headerSearchAllCollectionView.indexPath(for: cell) else { return }
        
        let itemId = filteredFitnessApp[indexPath.row].id
        if let indexInFullData = indexFitnessApp.firstIndex(where: { $0.id == itemId }) {
            indexFitnessApp[indexInFullData].isFavoriteHeader.toggle()
        }
        
        filteredFitnessApp[indexPath.row].isFavoriteHeader.toggle()
        
        let isFavorite = filteredFitnessApp[indexPath.row].isFavoriteHeader
        cell.setFavorite(isFavorite: isFavorite)

        let apiURL = "https://67c5afd9351c081993fb04e9.mockapi.io/api/fitnessApp/searchApi/\(itemId)"
        var request = URLRequest(url: URL(string: apiURL)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["isFavoriteHeader": isFavorite], options: [])
        URLSession.shared.dataTask(with: request).resume()

        Database.database().reference().child("favorites").child(itemId).setValue(["isFavoriteHeader": isFavorite])
    }
}
