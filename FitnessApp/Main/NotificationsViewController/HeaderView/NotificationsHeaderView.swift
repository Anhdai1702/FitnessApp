//
//  NotificationsHeaderView.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 27/3/25.
//

import UIKit

protocol NotificationsHeaderViewDelegate: AnyObject {
    func didSelectSection(_ section: Int)
}

class NotificationsHeaderView: NibView {
    
    @IBOutlet weak var remindersView: UIView!
    @IBOutlet weak var systemView: UIView!
    @IBOutlet private weak var remindersLabel: UILabel!
    @IBOutlet private weak var systemLabel: UILabel!
    
    weak var delegate: NotificationsHeaderViewDelegate?
    
    private var labels: [UILabel] {
        return [remindersLabel, systemLabel]
    }
    
    private var sectionTitles: [String] {
        return ["reminders_title".localized(), "system_title".localized()]
    }
    
    private var headerView: [UIView] {
        return [remindersView, systemView]
    }
            
    override func configureView() {
        super.configureView()
        setupSelect(section: 0)
    }
    
    @IBAction func didTapReminder(_ sender: Any) {
        delegate?.didSelectSection(0)
    }
    @IBAction func didTapSystem(_ sender: Any) {
        delegate?.didSelectSection(1)
    }
    
    func setupSelect(section: Int) {
        for (index, label) in labels.enumerated() {
            label.text = sectionTitles[index]
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = (index == section) ? UIColor.black : UIColor(resource: .lightPurple)
        }
        
        for (index, uiview) in headerView.enumerated() {
            uiview.backgroundColor = (index == section) ? UIColor(resource: .lightGreen) : UIColor.white
        }
    }
}
