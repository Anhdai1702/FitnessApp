//
//  SetUpViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 8/3/25.
//

import UIKit

class StartSetUpViewController: UIViewController {

    @IBOutlet private weak var introduceLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet weak var setupScrollView: UIScrollView!
    
    @IBOutlet private weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        introduceLabel.text = "consistency_message".localized()
        detailLabel.text = "detail_introduce".localized()
        nextBtn.setTitle("next".localized(), for: .normal)
        setupScrollView.contentInsetAdjustmentBehavior = .never
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        push(viewControllerType: GenderViewController.self)
    }
}
