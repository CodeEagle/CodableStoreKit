//
//  ViewController.swift
//  Example-iOS
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import UIKit
import CodableStoreKit

class ViewController: CodableStoreTableViewController<User> {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        for _ in 1..<5 {
            let user = User(id: UUID().uuidString, firstName: UUID().uuidString, lastName: UUID().uuidString)
            _ = try? self.codableStore.save(user)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = self.object(at: indexPath.row)
        cell.textLabel?.text = user?.firstName
        cell.detailTextLabel?.text = user?.lastName
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }

}
