//
//  WeightSelectionViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 10/3/25.
//

import UIKit

enum WeightUnit: String {
    case kg = "kg"
    case lb = "lb"
}

class WeightSelectionViewController: UIViewController {
    
    @IBOutlet private weak var numberCollectionView: UICollectionView!
    @IBOutlet private weak var selectNumberCollectionView: UICollectionView!
    
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var unitOfWeight: UILabel!
    @IBOutlet private weak var backLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    
    @IBOutlet private weak var nextBtn: UIButton!
    
    
    private let numbers = Array(0...500)
    private var selectedIndex = 75

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
extension WeightSelectionViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSelectKG(_ sender: Any) {
        unitOfWeight.text = WeightUnit.kg.rawValue
    }
    
    @IBAction func didTapSelectLB(_ sender: Any) {
        unitOfWeight.text = WeightUnit.lb.rawValue
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        push(viewControllerType: HeightSelectionViewController.self)
    }
}

// MARK: - Custom UI
extension WeightSelectionViewController {
    
    private func setupUI() {
        setupCollectionView()
        updateNumberLabel()
        setupLabel()
        setupLocalized()
    }
    
    private func setupLocalized() {
        backLabel.text = "back".localized()
        detailLabel.text = "detail_introduce".localized()
        questionLabel.text = "weight_question".localized()
        nextBtn.setTitle("next".localized(), for: .normal)
    }
    
    private func setupLabel() {
        unitOfWeight.text = WeightUnit.kg.rawValue
    }
    
    private func updateNumberLabel() {
        numberLabel.text = "\(numbers[selectedIndex])"
    }
    
    // Update selectedIndex and synchronize two collection views
    private func updateSelectedIndex(to index: Int, animated: Bool) {
        guard index != selectedIndex else { return }
        selectedIndex = index
        updateNumberLabel()
        numberCollectionView.reloadData()
        selectNumberCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.scrollToSelectedIndex(animated: animated)
        }
    }

    private func scrollToSelectedIndex(animated: Bool) {
        if let index = numbers.firstIndex(of: selectedIndex) {
            numberCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
            selectNumberCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: selectNumberCollectionView.frame.height)
        selectNumberCollectionView.collectionViewLayout = layout

        let numberLayout = UICollectionViewFlowLayout()
        numberLayout.scrollDirection = .horizontal
        numberLayout.itemSize = CGSize(width: 50, height: numberCollectionView.frame.height)
        numberCollectionView.collectionViewLayout = numberLayout

        numberCollectionView.dataSource = self
        numberCollectionView.delegate = self
        selectNumberCollectionView.dataSource = self
        selectNumberCollectionView.delegate = self

        numberCollectionView.register(UINib(nibName: "NumberCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: "NumberCollectionViewCell")
        selectNumberCollectionView.register(UINib(nibName: "SelectNumberCollectionViewCell", bundle: nil),
                                            forCellWithReuseIdentifier: "SelectNumberCollectionViewCell")

        DispatchQueue.main.async {
            self.scrollToSelectedIndex(animated: false)
        }

        selectNumberCollectionView.decelerationRate = .fast
        numberCollectionView.decelerationRate = .fast
    }
}

// MARK: - CollectionView: DataSource, Delegate, FlowLayout
extension WeightSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == numberCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCollectionViewCell", for: indexPath) as! NumberCollectionViewCell
            cell.configure(with: numbers[indexPath.item], isSelected: indexPath.item == selectedIndex)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectNumberCollectionViewCell", for: indexPath) as! SelectNumberCollectionViewCell
            cell.configure(number: numbers[indexPath.item], isSelected: indexPath.item == selectedIndex)
            return cell
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = selectNumberCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthWithSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let estimatedIndex = (targetContentOffset.pointee.x + scrollView.frame.width / 2) / cellWidthWithSpacing
        var index = Int(round(estimatedIndex))
        index = max(0, min(index, numbers.count - 1))
        updateSelectedIndex(to: index, animated: true)
        // Automatically scroll to exact position
        let newOffset = CGFloat(index) * cellWidthWithSpacing - (scrollView.frame.width - cellWidthWithSpacing) / 2
        targetContentOffset.pointee.x = newOffset
    }
}
