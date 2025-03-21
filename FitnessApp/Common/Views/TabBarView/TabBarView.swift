//
//  TabBarView.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 19/3/25.
//

import Foundation
import UIKit

protocol TabBarViewDelegate: AnyObject {
    func didSelectTab(at index: Int)
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
    
    @IBAction func didTapTab(_ sender: UIButton) {
        let index = sender.tag
        delegate?.didSelectTab(at: index)
        setupDashboard(section: index)
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
        guard section >= 0, section < images.count else { return }
        for (index, imageView) in images.enumerated() {
            imageView.image = (index == section) ? UIImage(resource: selectedImageResources[index]) : UIImage(resource: imageResources[index])
        }
    }
}
