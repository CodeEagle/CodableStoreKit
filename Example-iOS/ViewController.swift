//
//  ViewController.swift
//  Example-iOS
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import UIKit
import CodableStoreKit

class ViewController: UIViewController {
    
    let codableStore = CodableStore<User>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

}
