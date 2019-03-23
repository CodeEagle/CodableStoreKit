//
//  ViewController.swift
//  Example
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import CodableStoreKit
import UIKit

class ViewController: UIViewController {
    
    let codableStore = CodableStore<User>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var users: [User] = .init()
        for _ in 1...20000 {
            users.append(.random)
        }
        print("Start")
        let startTime = Date()
        try! self.codableStore.save(users)
        let endTime = Date()
        print("Saving: Elapsed Time: \(endTime.timeIntervalSince(startTime))")
        let startTimeFetch = Date()
        let fetchedUsers = try! self.codableStore.getCollection()
        let endTimeFetch = Date()
        print("Fetching: Elapsed Time: \(endTimeFetch.timeIntervalSince(startTimeFetch)) | Count: \(fetchedUsers.count)")
    }

}
