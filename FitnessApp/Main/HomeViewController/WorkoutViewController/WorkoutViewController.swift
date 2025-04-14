//
//  WorkoutViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 4/3/25.
//
import UIKit
import FirebaseDatabase

enum SelectWorkout {
    case beginner
    case intermediate
    case advanced
}

class WorkoutViewController: UIViewController {
    
    @IBOutlet private weak var titleWorkoutLabel: UILabel!
    @IBOutlet private weak var workoutTableView: UITableView!
    
    private var indexFitnessItemsCollectionView = [IndexFitness]()
    private var indexFitnessItemsTableView = [IndexFitness]()
    
    private var isSelectedBeginner = SelectWorkout.beginner
    
    
    struct workoutConstants {
        static let titleColor = UIColor(hex: "#896CFE")
        static let numbersOfSection = 3
        static let heightForRow: CGFloat = 120
        
        static let heightForHeaderInSection: [Int: CGFloat] = [
            0: 60,
            1: 242,
            2: 87
        ]
    }
    
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
extension WorkoutViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSearch(_ sender: Any) {
        push(viewControllerType: SearchViewController.self)
    }
    
    @IBAction func didTapNotification(_ sender: Any) {
        push(viewControllerType: NotificationsViewController.self)
    }
    
    @IBAction func didTapUser(_ sender: Any) {
        push(viewControllerType: UserProfileViewController.self)
    }
}

// MARK: Custom UI
extension WorkoutViewController {
    
    private func setupUI() {
        setupCollectionViewAndTableView()
        fetchData()
        setupLocalized()
    }
    
    private func setupLocalized() {
        titleWorkoutLabel.text = "workout".localized()
    }
    
    private func setupCollectionViewAndTableView() {
        workoutTableView.register(UINib(nibName: "WorkoutTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkoutTableViewCell")
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        self.workoutTableView.showsHorizontalScrollIndicator = false
        self.workoutTableView.showsVerticalScrollIndicator = false
    }
    
    private func fetchData() {
        IndexFitnessApp.shared.fetchFitnessData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.indexFitnessItemsCollectionView = data
                self.indexFitnessItemsTableView = data
                self.workoutTableView.reloadData()
            case .failure(_): break
            }
        }
    }
}

// MARK: - Actions
extension WorkoutViewController {
}

// MARK: - UITableView: DataSource, Delegate
extension WorkoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workoutConstants.numbersOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? indexFitnessItemsTableView.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTableViewCell", for: indexPath) as? WorkoutTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(model: indexFitnessItemsTableView[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return workoutConstants.heightForRow
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return LevelsHeaderView()
        case 1:
            let header = WorkoutHeaderView()
            header.delegate = self
            return header
        case 2:
            return TitleHeaderView()
        default:
            return nil
        }
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        workoutConstants.heightForHeaderInSection[section] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = indexFitnessItemsTableView[indexPath.row]
        let vc = BeginnerViewController()
        vc.selectedWorkout = data
        vc.listWorkout = [data]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - LevelsHeaderViewDelegate
extension WorkoutViewController: LevelsHeaderViewDelegate {
    
    func didTapBeginner() {
        push(viewControllerType: BeginnerViewController.self)
    }
    
    func didTapIntermediate() {
    }
    
    func didTapAdvanced() {
    }
}

//
extension WorkoutViewController: WorkoutHeaderViewDelegate {
    
    func workoutHeaderView(_ header: WorkoutHeaderView, didSelectWorkout workout: IndexFitness) {
        push(viewControllerType: BeginnerViewController.self)
    }
}
