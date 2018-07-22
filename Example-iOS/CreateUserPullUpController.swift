//
//  CreateUserPullUpController.swift
//  Example-iOS
//
//  Created by Sven Tiigi on 22.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import UIKit
import CodableStoreKit

class CreateUserPullUpController: PullUpController {
    
    lazy var codableStore: CodableStore<User> = .init()
    
    lazy var createButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(self.create), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .main
        self.view.addSubview(self.createButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.createButton.frame = self.view.bounds
    }
    
    @objc func create() {
        let user = User(id: UUID().uuidString, firstName: "Mr.", lastName: "Robot")
        _ = try? self.codableStore.save(user)
    }
    
}
