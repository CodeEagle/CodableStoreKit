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
    
    let subscriptionBag = CodableStoreSubscriptionBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let codableStore = CodableStore<User>()
        codableStore.observe("1") { event in
            print("OBSERVE")
            print(event)
        }.disposed(by: self.subscriptionBag)
        try! codableStore.save(User(identifier: "1", name: "Hello"))
        try! codableStore.save(User(identifier: "2", name: "Hello"))
        let user = try! codableStore.get("1")
        print(user)
        assert(user.name == "Hello")
    }
    
    func save(_ store: SaveableCodableStore<User>) {
        
    }


}

struct User: Codable, Equatable, Hashable {
    
    let identifier: String
    
    let name: String
    
}

extension User: CodableStorable {
    
    static var codableStoreIdentifier: KeyPath<User, String> {
        return \.identifier
    }
    
}
