//
//  User.swift
//  Example-iOS
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import CodableStoreKit
import Foundation

// MARK: - User

/// The User
struct User: Codable, Equatable {
    /// The identifier
    let id: String
    /// The first name
    let firstName: String
    /// The last name
    let lastName: String
}

// MARK: - CodableStoreable

extension User: CodableStoreable {
    
    /// The CodableStore unique identifier KeyPath
    static var codableStoreIdentifier: KeyPath<User, String> {
        return \User.id
    }
 
}
