//
//  TabBarView.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 19/3/25.
//

import Foundation
import UIKit

protocol TabBarViewDelegate: AnyObject {
    func didTapHome()
    func didTapResources()
    func didTapFavorite()
    func didTapSupport()
}

class TabBarView: NibView {
    
    @IBOutlet private weak var homeImage: UIImageView!
    @IBOutlet private weak var resourcesImage: UIImageView!
    @IBOutlet private weak var favoriteImage: UIImageView!
    @IBOutlet private weak var supportImage: UIImageView!
    
    weak var delegate: TabBarViewDelegate?
    
    private var images: [UIImageView] {
        return [homeImage, resourcesImage, favoriteImage, supportImage]
    }
    
    private var imageResources: [ImageResource] {
        return [.homeOff, .documentOff, .starOff, .supportOff]
    }
    
    private var selectedImageResources: [ImageResource] {
        return [.homeOn, .documentOn, .starOn, .supportOn]
    }
    
    override func configureView() {
        super.configureView()
        setupUI()
    }
}

// MARK: - Actions
extension TabBarView {
    
    @IBAction func didTapHome(_ sender: Any) {
        self.delegate?.didTapHome()
        setupDashboard(section: 0)
    }
    
    @IBAction func didTapDocument(_ sender: Any) {
        self.delegate?.didTapResources()
        setupDashboard(section: 1)
    }
    
    @IBAction func didTapStar(_ sender: Any) {
        self.delegate?.didTapFavorite()
        setupDashboard(section: 2)
    }
    
    @IBAction func didTapSupport(_ sender: Any) {
        self.delegate?.didTapSupport()
        setupDashboard(section: 3)
    }
}

// MARK: - Custom UI
extension TabBarView {
    
    private func setupUI() {
        setupInitialState()
    }
    
    private func setupInitialState() {
        setupDashboard(section: 0)
    }
    
    private func setupDashboard(section: Int) {
        for (index, imageView) in images.enumerated() {
            imageView.image = (index == section) ? UIImage(resource: selectedImageResources[index]) : UIImage(resource: imageResources[index])
        }
    }
}
