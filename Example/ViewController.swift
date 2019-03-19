//
//  ViewController.swift
//  Example
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import CodableStoreKit
import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    let codableStore = CodableStore<User>()
    
    lazy var users = (try? self.codableStore.getCollection()) ?? .init()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2 + .init(i)) {
                self.saveRandomUser()
            }
        }
    }
    
    func saveRandomUser() {
        _ = try? self.codableStore.save(.random)
    }
    
    override func loadView() {
        self.view = self.tableView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.users[indexPath.row].identifier
        return cell
    }

}
