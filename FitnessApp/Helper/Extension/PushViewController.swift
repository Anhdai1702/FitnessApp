//
//  PushViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 6/3/25.
//

import Foundation
import UIKit

extension UIViewController {
    func push<T: UIViewController>(viewControllerType: T.Type, animated: Bool = true) {
        let vc = T(nibName: String(describing: viewControllerType), bundle: nil)
        self.navigationController?.pushViewController(vc, animated: animated)
    }
}
