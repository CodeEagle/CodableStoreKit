//
//  ViewController.swift
//  Example
//
//  Created by Sven Tiigi on 20.11.2019.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import UIKit
import CodableStoreKit

// MARK: - ViewController

/// The ViewController
class ViewController: UIViewController {

    // MARK: Properties
    
    /// The Label
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "🚀\nCodableStoreKit\nExample"
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    // MARK: View-Lifecycle
    
    /// View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let codableStore = CodableStore<User>()
        switch codableStore.delete("1") {
        case .success:
            break
        case .failure(let error):
            print(error)
        }
    }
    
    /// LoadView
    override func loadView() {
        self.view = self.label
    }

}

struct User: CodableStorable {
    
    let id: String
    
    let name: String
    
    static var codableStoreIdentifier: KeyPath<User, String> {
        return \.id
    }
    
}
