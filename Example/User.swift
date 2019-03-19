//
//  User.swift
//  Example
//
//  Created by Sven Tiigi on 19.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import CodableStoreKit
import Foundation

// MARK: - User

/// The User
struct User: Codable, Equatable, Hashable {
    
    /// The Identifier
    let identifier: String
    
    /// The first Name
    let firstName: String
    
    /// The last Name
    let lastName: String
    
}

// MARK: - CodableStorable

extension User: CodableStorable {
    
    /// The CodableStore unique Identifier KeyPath
    static var codableStoreIdentifier: KeyPath<User, String> {
        return \.identifier
    }
    
}

// MARK: - Random

extension User {
    
    /// A random User
    static var random: User {
        return .init(
            identifier: UUID().uuidString,
            firstName: UUID().uuidString,
            lastName: UUID().uuidString
        )
    }
    
}
