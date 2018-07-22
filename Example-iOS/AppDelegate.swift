//
//  AppDelegate.swift
//  Example-iOS
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// The UIWindow
    var window: UIWindow?
    
    /// The UINavigationController with ViewController as root viewcontroller
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: UsersViewController())
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.main
        ]
        navigationController.view.backgroundColor = .white
        navigationController.navigationBar.tintColor = .main
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.main
        ]
        return navigationController
    }()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        return true
    }

}

