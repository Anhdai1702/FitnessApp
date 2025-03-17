//
//  SetPasswordViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 16/3/25.
//

import UIKit

class SetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func didTapFinish(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
