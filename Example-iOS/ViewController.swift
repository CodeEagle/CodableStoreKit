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
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        view.startAnimating()
        return view
    }()
    
    let bag = ObserverableCodableStoreSubscriptionBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.activityIndicator)
        let codableStore = CodableStore<User>()
        let subscription = codableStore.observe(where: { $0.firstName.contains("Max") }) { (event) in
            print("Object Observe FirstName is Max: \(event)")
        }
        User.codableStoreCollectionName
        codableStore.observe(identifier: "123") { (event) in
            print("Object Observe 123: \(event)")
        }.disposed(by: self.bag)
        let user = User(id: "123", firstName: "Max von Hag", lastName: "")
        try! user.save()
        user.observe { (event) in
            
        }
        subscription.unsubscribe()
        let user2 = User(id: "sdfsdf", firstName: "sadfsdf", lastName: "asdasd")
        try! user2.save()
        try! user.delete()
        
        User.observe(where: { $0.lastName.contains("Robot") }) { (event) in
            
        }
        let prf = ProfileViewController(readableCodableStore: codableStore)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.activityIndicator.frame = self.view.frame
    }


}


class ProfileViewController<T: ReadableCodableStore> where T.Object == User {
    
    let readableCodableStore: T
    
    init(readableCodableStore: T) {
        self.readableCodableStore = readableCodableStore
    }
    
}
