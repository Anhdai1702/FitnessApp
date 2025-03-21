//
//  AgeSelectionViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 10/3/25.
//

import UIKit

class AgeSelectionViewController: UIViewController {
    
    @IBOutlet private weak var backLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    
    @IBOutlet private weak var AgeSelectionCollectionView: UICollectionView!
    
    @IBOutlet private weak var nextBtn: UIButton!
    
    private let ages = Array(10...100)
    private var selectedAge: Int = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - Actions
extension AgeSelectionViewController {
    @IBAction func didTapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        push(viewControllerType: WeightSelectionViewController.self)
    }
}

// MARK: - Custom UI
extension AgeSelectionViewController {
    
    private func setupUI() {
        setupCollectionView()
        setupLocalized()
    }
    
    private func setupLocalized() {
        backLabel.text = "back".localized()
        questionLabel.text = "age_question".localized()
        detailLabel.text = "detail_introduce".localized()
        nextBtn.setTitle("next".localized(), for: .normal)
    }
    
    private func updateAgeLabel() {
        ageLabel.text = "\(selectedAge)"
    }
    
    private func updateSelectedAge(at index: Int, animated: Bool) {
        selectedAge = ages[index]
        updateAgeLabel()
        scrollToSelectedAge(animated: animated)
        AgeSelectionCollectionView.reloadData()
    }
    
    private func scrollToSelectedAge(animated: Bool) {
        if let index = ages.firstIndex(of: selectedAge) {
            AgeSelectionCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 91, height: 118)
        AgeSelectionCollectionView.collectionViewLayout = layout
        AgeSelectionCollectionView.dataSource = self
        AgeSelectionCollectionView.delegate = self
        AgeSelectionCollectionView.decelerationRate = .fast
        AgeSelectionCollectionView.register(UINib(nibName: "AgeCollectionViewCell", bundle: nil),
                                            forCellWithReuseIdentifier: "AgeCollectionViewCell")
        
        // Default selection
        DispatchQueue.main.async { self.scrollToSelectedAge(animated: false) }
        updateAgeLabel()
    }
}

// MARK: - CollectionViewDatasource, UICollectionViewDelegate
extension AgeSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AgeCollectionViewCell", for: indexPath) as! AgeCollectionViewCell
        cell.updateUI(age: ages[indexPath.item], isCentered: ages[indexPath.item] == selectedAge, borderWith: ages[indexPath.item] == selectedAge)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateSelectedAge(at: indexPath.item, animated: true)
    }
    
    // Adjusts scrolling behavior to ensure the selected item is always centered
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = AgeSelectionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthWithSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        let index = Int(round((targetContentOffset.pointee.x + scrollView.frame.width / 2) / cellWidthWithSpacing))
        updateSelectedAge(at: max(0, min(index, ages.count - 1)), animated: true)
        
        targetContentOffset.pointee.x = CGFloat(index) * cellWidthWithSpacing - (scrollView.frame.width - cellWidthWithSpacing) / 2
    }
}
