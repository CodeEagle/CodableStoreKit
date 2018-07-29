//
//  UsersTableViewController.swift
//  Example-iOS
//
//  Created by Sven Tiigi on 22.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import UIKit
import CodableStoreKit

/// The UsersViewController
class UsersViewController: CodableStoreViewController<User>, UITableViewDataSource {
    
    // MARK: UI-Properties
    
    /// The TableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        return tableView
    }()
    
    /// The CreateUserPullUpController
    lazy var createUserPullUpController = CreateUserPullUpController()
    
    // MARK: View-Lifecycle
    
    /// ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CodableStoreKit"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        self.addPullUpController(self.createUserPullUpController)
    }
    
    /// ViewDidLayoutSubViews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.frame
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.codableStoreables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let user = self.codableStoreable(at: indexPath.row) else {
            return cell
        }
        cell.textLabel?.textColor = .main
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.codableStoreables.isEmpty {
            return nil
        } else {
           return "Users"
        }
    }
    
}
