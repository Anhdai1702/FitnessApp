//
//  BeginnerViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 5/4/25.
//

import UIKit

class BeginnerViewController: UIViewController {
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemView: UIView!
    
    @IBOutlet private weak var navigationBarView: UIView!
    @IBOutlet private weak var beginnerTableView: UITableView!
    @IBOutlet weak var topNavigationBar: NSLayoutConstraint!
    
    var beginnerWorkouts : [IndexFitness] = []
    var selectedWorkout: IndexFitness?
    var listWorkout: [IndexFitness] = []
    
    var headerBeginnerView: BeginnerHeaderView?
    
    private var lastContentOffset: CGFloat = 0
    private var isNavigationBarHidden = false

    struct BeginnerConstants {
        static let titleColor = UIColor(hex: "#896CFE")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Custom UI
extension BeginnerViewController {
    
    private func setupUI() {
        setupTableView()
        setupBeginnerHeaderView()
    }

    private func setupTableView() {
        beginnerTableView.register(UINib(nibName: "BeginnerTableViewCell", bundle: nil), forCellReuseIdentifier: "BeginnerTableViewCell")
        beginnerTableView.dataSource = self
        beginnerTableView.delegate = self
    }
    
     func setupBeginnerHeaderView() {
        headerBeginnerView?.fetchDataWorkout()
    }
}

// MARK: - Actions
extension BeginnerViewController {
    
}

// MARK: - UITableView: Datasource, Delegate
extension BeginnerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? listWorkout.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if indexPath.section == 1 {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeginnerTableViewCell", for: indexPath) as? BeginnerTableViewCell else {
               return UITableViewCell()
           }
           
           return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
             let headerView = BeginnerHeaderView()
            headerView.selectedWorkout = selectedWorkout // ✅ Truyền dữ liệu vào header
            headerView.fetchDataWorkout() // ✅ Gọi load ảnh
            self.headerBeginnerView = headerView // ✅ Lưu reference nếu cần dùng sau
            return headerView
        } else {
            return TitleSectionHeaderView()
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        74
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 208 : 70
    }
}

// MARK: - Scroll View Handling
extension BeginnerViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let isScrollingDown = currentOffset > lastContentOffset
        let isScrollingUp = currentOffset < lastContentOffset

        let navigationBarHeight = navigationBarView.bounds.height + 16

        // Hàm ẩn hoặc hiển thị navigation bar
        func toggleNavigationBar(hidden: Bool) {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.itemView.alpha = hidden ? 0 : 1
                self.titleLabel.alpha = hidden ? 0 : 1
                self.backImage.alpha = hidden ? 0 : 1
                self.topNavigationBar.constant = hidden ? -navigationBarHeight : 0
                self.view.layoutIfNeeded()
            }) { _ in
                self.isNavigationBarHidden = hidden
            }
        }

        // check scroll down và scroll up
        if isScrollingDown && currentOffset > 10 && !isNavigationBarHidden {
            toggleNavigationBar(hidden: true)
        } else if isScrollingUp && isNavigationBarHidden {
            toggleNavigationBar(hidden: false)
        }

        lastContentOffset = currentOffset
    }
}
