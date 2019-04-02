//
//  User.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 23.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

@testable import CodableStoreKit
import Foundation

// MARK: - User

/// The User
struct User: Codable {
    
    /// The Identifier
    let identifier: String
    
    /// The FirstName
    let firstName: String
    
    /// The LastName
    let lastName: String
    
}

// MARK: - CodableStorable

extension User: CodableStorable {
    
    /// The CodableStore unique Identifier KeyPath
    static var codableStoreIdentifier: KeyPath<User, String> {
        return \.identifier
    }
    
}
