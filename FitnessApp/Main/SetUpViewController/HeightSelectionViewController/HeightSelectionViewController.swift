//
//  HeightSelectionViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài on 10/3/25.
//

import UIKit

class HeightSelectionViewController: UIViewController {
    
    @IBOutlet private weak var backLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var heightNumberLabel: UILabel!
    
    @IBOutlet private weak var selectHeightCollectionView: UICollectionView!
    @IBOutlet private weak var weelCollectionView: UICollectionView!
    
    @IBOutlet private weak var nextBtn: UIButton!
    
    private let numbers = Array(100...300)
    private var selectedIndex = 170
    
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
extension HeightSelectionViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        push(viewControllerType: GoalSelectionViewController.self)
    }
}

// MARK: - Custom UI
extension HeightSelectionViewController {
    
    private func setupUI() {
        setupCollectionView()
        updateSelectedHeight()
        setupLocalized()
    }
    
    private func setupLocalized() {
        backLabel.text = "back".localized()
        questionLabel.text = "height_question".localized()
        detailLabel.text = "detail_introduce".localized()
        nextBtn.setTitle("next".localized(), for: .normal)
    }
    
    private func setupCollectionView() {
        selectHeightCollectionView.register(UINib(nibName: "SelectHeightCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectHeightCollectionViewCell")
        weelCollectionView.register(UINib(nibName: "WeelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WeelCollectionViewCell")
        
        selectHeightCollectionView.delegate = self
        selectHeightCollectionView.dataSource = self
        weelCollectionView.delegate = self
        weelCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: selectHeightCollectionView.frame.width, height: 50)
        selectHeightCollectionView.collectionViewLayout = layout
        
        let numberLayout = UICollectionViewFlowLayout()
        numberLayout.scrollDirection = .vertical
        numberLayout.itemSize = CGSize(width: weelCollectionView.frame.width, height: 50)
        weelCollectionView.collectionViewLayout = numberLayout
        DispatchQueue.main.async {
            self.scrollToSelectedIndex(animated: false)
        }
        
        selectHeightCollectionView.decelerationRate = .fast
        weelCollectionView.decelerationRate = .fast
    }
    
    private func updateSelectedHeight() {
        heightNumberLabel.text = "\(numbers[selectedIndex])"
    }
    
    private func updateSelectedIndex(to index: Int, animated: Bool) {
        guard index != selectedIndex else { return }
        selectedIndex = index
        updateSelectedHeight()
        weelCollectionView.reloadData()
        selectHeightCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.scrollToSelectedIndex(animated: animated)
        }
    }
    
    private func scrollToSelectedIndex(animated: Bool) {
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        weelCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: animated)
        selectHeightCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: animated)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension HeightSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == selectHeightCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectHeightCollectionViewCell", for: indexPath) as! SelectHeightCollectionViewCell
            cell.configure(with: numbers[indexPath.item], isSelected: indexPath.item == selectedIndex)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeelCollectionViewCell", for: indexPath) as! WeelCollectionViewCell
            cell.configure(numbers: numbers[indexPath.item], isSelected: indexPath.item == selectedIndex)
            return cell
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = weelCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellHeightWithSpacing = layout.itemSize.height + layout.minimumLineSpacing
        let estimatedIndex = (targetContentOffset.pointee.y + scrollView.frame.height / 2) / cellHeightWithSpacing
        var index = Int(round(estimatedIndex))
        index = max(0, min(index, numbers.count - 1))
        updateSelectedIndex(to: index, animated: true)
        targetContentOffset.pointee.y = CGFloat(index) * cellHeightWithSpacing - (scrollView.frame.height - cellHeightWithSpacing) / 2
    }
}
