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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let codableStore = CodableStore<User>()
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
