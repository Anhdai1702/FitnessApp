//
//  NotificationsViewController.swift
//  FitnessApp
//
//  Created by Phùng Anh Đài  on 20/3/25.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet private weak var notificationsLabel: UILabel!
    @IBOutlet private weak var notificationsTableView: UITableView!
    @IBOutlet private weak var remindersBtn: UIButton!
    @IBOutlet private weak var systemBtn: UIButton!
    
    private var sections: [NotificationType] = []
    private var notificationsHeaderView: NotificationsHeaderView?
    
    private struct NotifConsts {
        static let heightForRowAt: CGFloat = 74
        static let heightForTitleInFirstSection: CGFloat = 72
        static let heightForTitleInRest: CGFloat = 51
        static let heightTitleView: CGFloat = 18
        static let firstSectionSpacing: CGFloat = 49
        static let otherSectionsSpacing: CGFloat = 27
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - Actions
extension NotificationsViewController {
    
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSreach(_ sender: Any) {
    }
    
    @IBAction func didTapNotifications(_ sender: Any) {
    }
    
    @IBAction func didTapUser(_ sender: Any) {
        push(viewControllerType: UserProfileViewController.self)
    }
}

// MARK: - Custom UI
extension NotificationsViewController {
    
    private func setupUI() {
        setupLocalized()
        setupNotificationsTableView()
        loadSections()
        
    }
    
    private func loadSections() {
      sections = NotificationType.allCases
    }
    
    private func setupLocalized() {
        notificationsLabel.text = "notifications".localized()
    }
    
    private func setupNotificationsTableView() {
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
    }
    
    private func handleHeaderSelection(section: Int) {
        guard let headerView = notificationsTableView.headerView(forSection: 0) as? NotificationsHeaderView else { return }
        headerView.setupSelect(section: section)

        // Cập nhật UI dựa trên section
        print("Selected section: \(section)")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NotificationsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as? NotificationsTableViewCell else
        {return UITableViewCell()}
        cell.configure(model: sections[indexPath.section].items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NotifConsts.heightForRowAt
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = NotificationSection(rawValue: section) else { return nil }
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: section == 0 ? NotifConsts.heightForTitleInFirstSection : NotifConsts.heightForTitleInRest))
        let titleView = TitleNotificationsView()
        titleView.frame = CGRect(x: 16, y: section == 0 ? NotifConsts.firstSectionSpacing : NotifConsts.otherSectionsSpacing, width: tableView.frame.width, height: NotifConsts.heightTitleView)
        titleView.configure(with: sectionType.title)
        containerView.addSubview(titleView)

        if section == 0 {
            let headerView = NotificationsHeaderView()
            headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30)
            headerView.delegate = self
            notificationsHeaderView = headerView
            containerView.addSubview(headerView)
        }
        return containerView
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? NotifConsts.heightForTitleInFirstSection : NotifConsts.heightForTitleInRest
    }
}

extension NotificationsViewController: NotificationsHeaderViewDelegate {
    
    func didSelectSection(_ section: Int) {
        notificationsHeaderView?.setupSelect(section: section)
    }
}
