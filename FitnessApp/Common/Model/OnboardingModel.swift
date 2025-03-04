//
//  OnboardingModel.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 4/3/25.
//

import Foundation
import UIKit

struct OnboardingSlide {
    var imageBackground: UIImage
    var imageDetail: UIImage?
    var title: String
}

extension OnboardingSlide {
    static let allSlides: [OnboardingSlide]
    =
    [
        OnboardingSlide(imageBackground: .onboarding2, imageDetail: .run, title: "Start your journey towards a more active lifestyle"),
        OnboardingSlide(imageBackground: .onboarding3, imageDetail: .health, title: "Find nutrition tips that fit your lifestyle"),
        OnboardingSlide(imageBackground: .onboarding4, imageDetail: .community, title: "A community for you, challenge yourself")
    ]
}
