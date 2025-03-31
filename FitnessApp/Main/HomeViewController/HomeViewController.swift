//
//  HomeViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 4/3/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var yourNameLabel: UILabel!
    @IBOutlet private weak var detailHomeLabel: UILabel!
    @IBOutlet private weak var workoutLabel: UILabel!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var nutritionLabel: UILabel!
    @IBOutlet private weak var communityLabel: UILabel!
    @IBOutlet private weak var recommendationsLabel: UILabel!
    @IBOutlet private weak var seeAllLabel: UILabel!
    @IBOutlet private weak var squatExerciseLabel: UILabel!
    @IBOutlet private weak var fullBodyStretchingLabel: UILabel!
    @IBOutlet private weak var practiceTimeLabel: UILabel!
    @IBOutlet private weak var caloLabel: UILabel!
    @IBOutlet private weak var practiceTimeFullBodyLabel: UILabel!
    @IBOutlet private weak var caloFullBodyLabel: UILabel!
    @IBOutlet private weak var weeklyChallengeLabel: UILabel!
    @IBOutlet private weak var plankWithHipTwistLabel: UILabel!
    @IBOutlet private weak var articlesAndTipsLabel: UILabel!
    @IBOutlet private weak var SupplementGuideLabel: UILabel!
    @IBOutlet private weak var quickAndEffectiveDailyRoutinesLabel: UILabel!
    
    @IBOutlet private weak var workoutImage: UIImageView!
    @IBOutlet private weak var progressImage: UIImageView!
    @IBOutlet private weak var nutritionImage: UIImageView!
    @IBOutlet private weak var communityImage: UIImageView!
    @IBOutlet private weak var squatExerciseImage: UIImageView!
    @IBOutlet private weak var fullBodyStretchingImage: UIImageView!
    @IBOutlet private weak var supplementGuideImage: UIImageView!
    @IBOutlet private weak var quickAndEffectiveImage: UIImageView!
    @IBOutlet private weak var weeklyChallengeImage: UIImageView!
    
    private var recommendationsImages: [UIImageView] = []
    private var articlesAndTipsImages: [UIImageView] = []
    
    private var images: [UIImageView] {
        return [workoutImage, progressImage, nutritionImage, communityImage]
    }
    
    private var labels: [UILabel] {
        return [workoutLabel, progressLabel, nutritionLabel, communityLabel]
    }
    
    private var sectionTitles: [String] {
        return ["workout", "progress_tracking", "nutrition", "community"]
    }
    
    private var imageResources: [ImageResource] {
        return [.workoutOff, .progressTrackingOff, .nutritionOff, .communityOff]
    }
    
    private var selectedImageResources: [ImageResource] {
        return [.workoutOn, .progressTrackingOn, .nutritionOn, .communityOn]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileDidUpdate), name: NSNotification.Name("UserProfileUpdated"), object: nil)
    }
    
    @objc private func userProfileDidUpdate() {
        fetchUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

// MARK: - Actions
extension HomeViewController {
    
    @IBAction func didTapSearch(_ sender: Any) {
        push(viewControllerType: SearchViewController.self)
    }
    
    @IBAction func didTapNotification(_ sender: Any) {
        push(viewControllerType: NotificationsViewController.self)
    }
    
    @IBAction func didTapUser(_ sender: Any) {
        push(viewControllerType: UserProfileViewController.self)
    }
    
    @IBAction func didTapWorkout(_ sender: Any) {
        setupSelectRegime(section: 0)
    }
    
    @IBAction func didTapProgressTracking(_ sender: Any) {
        setupSelectRegime(section: 1)
    }
    
    @IBAction func didTapNutrition(_ sender: Any) {
        setupSelectRegime(section: 2)
    }
    
    @IBAction func didTapCommunity(_ sender: Any) {
        setupSelectRegime(section: 3)
    }
    
    @IBAction func didTapSeeAll(_ sender: Any) {
    }
    
    @IBAction func didTapSquatVideo(_ sender: Any) {
    }
    
    @IBAction func didTapFullBodyVideo(_ sender: Any) {
    }
    
    @IBAction func didTapFavoriteSquat(_ sender: Any) {
    }
    
    @IBAction func didTapFavoriteFullBody(_ sender: Any) {
    }
    
    @IBAction func didTapFavoriteSupplementGuide(_ sender: Any) {
    }
    
    @IBAction func didTapEffectiveDailyRoutines(_ sender: Any) {
    }

}

// MARK: - Custom UI
extension HomeViewController {
    
    private func setupUI() {
        setupLocalized()
        setupSelectRegime(section: 0)
        fetchAndDisplayFitnessData()
        apiImages()
        fetchUserData()
    }
    
    private func setupLocalized() {
        yourNameLabel.text = "your_name".localized()
        detailHomeLabel.text = "detail_home".localized()
        workoutLabel.text = "workout".localized()
        progressLabel.text = "progress_tracking".localized()
        nutritionLabel.text = "nutrition".localized()
        communityLabel.text = "community".localized()
        recommendationsLabel.text = "recommendations".localized()
        seeAllLabel.text = "see_all".localized()
        squatExerciseLabel.text = "squat".localized()
        fullBodyStretchingLabel.text = "full_body_stretching".localized()
        practiceTimeLabel.text = "practice_time".localized()
        caloLabel.text = "calories".localized()
        practiceTimeFullBodyLabel.text = "full_body".localized()
        weeklyChallengeLabel.text = "weekly_challenge".localized()
        plankWithHipTwistLabel.text = "plank_with_hip_twist".localized()
        articlesAndTipsLabel.text = "articles_and_tips".localized()
        SupplementGuideLabel.text = "supplement_guide".localized()
        quickAndEffectiveDailyRoutinesLabel.text = "quick_and_effective_daily_routines".localized()
    }
    
    private func setupSelectRegime(section: Int) {
        for (index, label) in labels.enumerated() {
            label.text = sectionTitles[index]
            label.font = UIFont.systemFont(ofSize: 10.83)
            label.textColor = (index == section) ? UIColor(resource: .lightGreen) : UIColor(resource: .lightPurple)
        }
        
        for (index, imageView) in images.enumerated() {
            imageView.image = (index == section) ? UIImage(resource: selectedImageResources[index]) : UIImage(resource: imageResources[index])
        }
    }
    
    private func apiImages() {
        recommendationsImages = [squatExerciseImage, fullBodyStretchingImage]
        articlesAndTipsImages = [supplementGuideImage, quickAndEffectiveImage]
    }
    
    private func fetchAndDisplayFitnessData() {
        FitnessAPIService.shared.fetchFitnessData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fitnessItems):
                guard !fitnessItems.isEmpty else { return }
                
                self.updateImages(self.recommendationsImages, with: fitnessItems.map { $0.recommendations })
                
                self.updateImages(self.articlesAndTipsImages, with: fitnessItems.map { $0.articles })
                
                if let firstItem = fitnessItems.first {
                    self.weeklyChallengeImage.loadImage(from: firstItem.weeklyChallenge)
                }
                
            case .failure: break
            }
        }
    }

    private func updateImages(_ imageViews: [UIImageView], with urls: [String]) {
        for (imageView, url) in zip(imageViews, urls) {
            imageView.loadImage(from: url)
        }
    }
    
    @objc private func fetchUserData() {
        UserService.shared.fetchUserData { [weak self] data in
            guard let self = self, let data = data else {
                return
            }
            DispatchQueue.main.async {
                self.yourNameLabel.text = data["fullName"] as? String ?? ""
            }
        }
    }
}
