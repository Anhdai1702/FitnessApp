//
//  Untitled.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 5/3/25.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, mess: String) {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithCancel(title: String, mess: String, onCancel: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Back to login", style: .cancel) { _ in
            onCancel()
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
