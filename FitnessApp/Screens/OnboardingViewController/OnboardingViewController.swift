import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var imageStartOnboarding: UIImageView!
    @IBOutlet weak var backgroundOnboarding: UIImageView!
    @IBOutlet weak var detailImageOnboarding: UIImageView!
    @IBOutlet weak var descriptionOnboarding: UILabel!
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var skipBtn: UIButton!
    
    var currentIndex = 0
    
    struct Constants {
        static let pageControlSize = CGSize(width: 20, height: 4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startWaitingScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - Actions
extension OnboardingViewController {
    
    @IBAction func didTapNext(_ sender: Any) {
        moveToNextSlide()
    }
    
    @IBAction func didTapSkip(_ sender: Any) {
        currentIndex = OnboardingSlide.allSlides.count - 1
        updateUI()
        skipBtn.isHidden = true
        nextBtn.setTitle("Start", for: .normal)
        onboardingCollectionView.reloadData()
    }
}

// MARK: - Custom Methods
extension OnboardingViewController {
    
    func setupUI() {
        registerCells()
        onboardingCollectionView.reloadData()
        setupBtn()
    }
    
    func registerCells() {
        onboardingCollectionView.register(UINib(nibName: "MoveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MoveCollectionViewCell")
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
    }
    
    
    
    func updateUI() {
        let slide = OnboardingSlide.allSlides[currentIndex]
        backgroundOnboarding.image = slide.imageBackground
        detailImageOnboarding.image = slide.imageDetail
        descriptionOnboarding.text = slide.title
    }
    
    func moveToNextSlide() {
        if currentIndex < OnboardingSlide.allSlides.count - 1 {
            currentIndex += 1
            scrollToCurrentSlide()
            updateUI()
            skipBtn.isHidden = true
            onboardingCollectionView.reloadData()
            if currentIndex == OnboardingSlide.allSlides.count - 1 {
                nextBtn.setTitle("Start", for: .normal)
            }
        } else {
            print("Onboarding Completed")
        }
    }
    
    private func startWaitingScreen() {
        toggleOnboardingVisibility(isHidden: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.showOnboarding()
        }
    }
    
    private func showOnboarding() {
        toggleOnboardingVisibility(isHidden: false)
        // Navigate to the first slide
        currentIndex = 0
        updateUI()
        scrollToCurrentSlide()
    }
    
    private func toggleOnboardingVisibility(isHidden: Bool) {
        imageStartOnboarding.isHidden = !isHidden
        onboardingCollectionView.isHidden = isHidden
        nextBtn.isHidden = isHidden
        detailView.isHidden = isHidden
        skipBtn.isHidden = isHidden
    }
    
    func setupBtn() {
        nextBtn.setTitle("Next", for: .normal)
        skipBtn.setTitle("Skip", for: .normal)
    }
    
    // Scrolls to the current slide in the collection view
    private func scrollToCurrentSlide() {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OnboardingSlide.allSlides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoveCollectionViewCell", for: indexPath) as! MoveCollectionViewCell
        cell.updateView(isSelect: currentIndex == indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView == onboardingCollectionView ? Constants.pageControlSize : collectionView.frame.size
    }
}

//extension UIView {
//  func addShadow() {
//    self.layer.shadowColor = UIColor.black.cgColor
//    self.layer.shadowOffset = CGSize(width: -1, height: 2)
//    self.layer.shadowRadius = 5
//    self.layer.shadowOpacity = 5
//  }
//}
