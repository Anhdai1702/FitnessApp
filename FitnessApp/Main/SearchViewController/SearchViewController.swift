//
//  SearchViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 29/3/25.
//

import UIKit
import FirebaseDatabase

enum SearchCategory: CaseIterable {
    
    case all, workout, nutrition
    
    var rowCount: Int { self == .all ? 10 : 4 }
    
    var rowHeight: CGFloat { self == .all ? 127 : 62 }
    
    var headerType: UIView.Type { self == .all ? HeaderSearchAllView.self : HeaderSearchWorkAndNutriView.self }
    
    var headerHeight: CGFloat { self == .all ? 179 : 70 }
}

class SearchViewController: UIViewController {
    
    @IBOutlet private weak var titleSearchLabel: UILabel!
    @IBOutlet private weak var searchAllLabel: UILabel!
    @IBOutlet private weak var searchWorkoutLabel: UILabel!
    @IBOutlet private weak var searchNutritionLabel: UILabel!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchTableView: UITableView!
    @IBOutlet private weak var searchAllView: UIView!
    @IBOutlet private weak var searchWorkoutView: UIView!
    @IBOutlet private weak var searchNutritonView: UIView!
    
    private var indexFitnessApp = [IndexFitness]()
    private var filteredFitnessApp = [IndexFitness]()
    private var filteredWorkoutData = [IndexFitness]()
    private var filteredNutritionData = [IndexFitness]()
    private var favoriteStatus: [String: Bool] = [:]
    private var headerSearchAllView: HeaderSearchAllView?
    private var currentCategory: SearchCategory = .workout
    
    private var labels: [UILabel] {
        return [searchAllLabel, searchWorkoutLabel, searchNutritionLabel]
    }
    
    private var sectionTitles: [String] {
        return ["All", "Workout", "Nutrition"]
    }
    
    private var changeColorUIView: [UIView] {
        return [searchAllView, searchWorkoutView, searchNutritonView]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Actions
extension SearchViewController {
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapNotification(_ sender: Any) {
        push(viewControllerType: NotificationsViewController.self)
    }
    
    @IBAction func didTapUserProfile(_ sender: Any) {
        push(viewControllerType: UserProfileViewController.self)
    }
    
    @IBAction func didTapSearchAll(_ sender: Any) {
        currentCategory = .all
        searchTableView.reloadData()
        setupSelectRegime(section: 0)
        filterData(with: searchTextField.text ?? "")
    }
    
    @IBAction func didTapSearchWorkout(_ sender: Any) {
        currentCategory = .workout
        searchTableView.reloadData()
        setupSelectRegime(section: 1)
        filterData(with: searchTextField.text ?? "")
        updateHeaderTitle()
    }
    
    @IBAction func didTapSearchNutrition(_ sender: Any) {
        currentCategory = .nutrition
        searchTableView.reloadData()
        setupSelectRegime(section: 2)
        filterData(with: searchTextField.text ?? "")
        updateHeaderTitle()
    }
}

// MARK: - Custom UI
extension SearchViewController {
    
    private func setupUI() {
        setupTableView()
        setupLocalizeed()
        fetchData()
        setupSelectRegime(section: 0)
        searchTextField.delegate = self
    }
    
    private func setupLocalizeed() {
        titleSearchLabel.text = "search_title".localized()
        searchAllLabel.text = "search_all".localized()
        searchWorkoutLabel.text = "search_workout".localized()
        searchNutritionLabel.text = "search_nutrition".localized()
        searchTextField.placeholder = "search_placeholder".localized()
    }
    
    private func fetchData() {
        IndexFitnessApp.shared.fetchFitnessData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.indexFitnessApp = data
                self.searchTableView.reloadData()
                self.filterData(with: "")
            case .failure(_): break
            }
        }
    }
    
    private func filterData(with keyword: String) {
        filteredFitnessApp = []
        filteredWorkoutData = []
        filteredNutritionData = []

        for item in indexFitnessApp {
            let matchesKeyword = keyword.isEmpty ||
                item.title.lowercased().contains(keyword.lowercased()) ||
                item.workoutContent.lowercased().contains(keyword.lowercased()) ||
                item.nutritionContent.lowercased().contains(keyword.lowercased())
            if matchesKeyword {
                filteredFitnessApp.append(item)
            }

            if !item.workoutContent.isEmpty && matchesKeyword {
                filteredWorkoutData.append(item)
            }

            if !item.nutritionContent.isEmpty && matchesKeyword {
                filteredNutritionData.append(item)
            }
        }
            self.headerSearchAllView?.filterData(with: keyword)
            self.searchTableView.reloadData()
    }

    private func setupTableView() {
        currentCategory = .all
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: "SearchAllTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchAllTableViewCell")
        searchTableView.register(UINib(nibName: "WorkoutAndNutritionTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkoutAndNutritionTableViewCell")
    }
    
    private func setupSelectRegime(section: Int) {
        
        for (index, label) in labels.enumerated() {
            label.text = sectionTitles[index]
            label.textColor = (index == section) ? UIColor.black : UIColor(resource: .lightPurple)
        }
        
        for (index, uiview) in changeColorUIView.enumerated() {
            uiview.backgroundColor = (index == section) ? UIColor(resource: .lightGreen) : UIColor.white
        }
    }
    
    private func updateHeaderTitle() {
        if let header = searchTableView.headerView(forSection: 0)?.contentView.subviews.first(where: { $0 is HeaderSearchWorkAndNutriView }) as? HeaderSearchWorkAndNutriView {
            header.configure(category: currentCategory)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentCategory {
        case .all: return filteredFitnessApp.count
        case .workout: return filteredWorkoutData.count
        case .nutrition: return filteredNutritionData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentCategory {
        case .all:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAllTableViewCell", for: indexPath) as! SearchAllTableViewCell
            cell.configure(model: filteredFitnessApp[indexPath.row])
            cell.delegate = self
            return cell
        case .workout:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutAndNutritionTableViewCell", for: indexPath) as! WorkoutAndNutritionTableViewCell
            cell.configure(model: filteredWorkoutData[indexPath.row], category: currentCategory)
            return cell
            
        case .nutrition:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutAndNutritionTableViewCell", for: indexPath) as! WorkoutAndNutritionTableViewCell
            cell.configure(model: filteredNutritionData[indexPath.row], category: currentCategory)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentCategory.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if currentCategory == .all {
            if headerSearchAllView == nil {
                let headerView = HeaderSearchAllView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 138))
                self.headerSearchAllView = headerView
            }
            return headerSearchAllView
        }
        else if let headerView = currentCategory.headerType.init() as? HeaderSearchWorkAndNutriView {
            headerView.configure(category: currentCategory)
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return currentCategory.headerHeight
    }
}

// MARK: - SearchAllTableViewCellDelegate
extension SearchViewController: SearchAllTableViewCellDelegate {
    func didTapFavorite(in cell: SearchAllTableViewCell) {
        guard let indexPath = searchTableView.indexPath(for: cell) else { return }
        indexFitnessApp[indexPath.row].isFavorite.toggle()

        let item = indexFitnessApp[indexPath.row]
        let apiURL = "https://67c5afd9351c081993fb04e9.mockapi.io/api/fitnessApp/searchApi/\(item.id)"
        var request = URLRequest(url: URL(string: apiURL)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["isFavorite": item.isFavorite], options: [])
        URLSession.shared.dataTask(with: request).resume()

        Database.database().reference().child("favorites").child(item.id).setValue(["isFavorite": item.isFavorite])
        cell.setFavorite(isFavorite: item.isFavorite)
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        filterData(with: newText)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        filterData(with: "")
        return true
    }
}

