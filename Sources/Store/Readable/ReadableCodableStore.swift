//
//  ReadableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 05.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - ReadableCodableStore

/// The ReadableCodableStore Protocol
public protocol ReadableCodableStore: ReadableCodableStoreEngine {
    
    /// Retrieve Objects with Filter
    ///
    /// - Parameter filter: The Filter
    /// - Returns: An array of matching objects
    /// - Throws: If retrieving fails
    func get(where filter: (Object) -> Bool) throws -> [Object]
    
    /// Retrieve first Object matching Filter
    ///
    /// - Parameter filter: The Filter
    /// - Returns: The matching Object
    /// - Throws: If retrieving fails
    func first(where filter: (Object) -> Bool) throws -> Object?
    
    /// Check if Object with Identifier exists
    ///
    /// - Parameter identifier: The Identifier
    /// - Returns: Boolean if Object exists
    func exists(identifier: Object.ID) -> Bool
    
    /// Check if Object exists
    ///
    /// - Parameter object: The Object
    /// - Returns: Boolean if Object exists
    func exists(_ object: Object) -> Bool
    
}

// MARK: - ReadableCodableStore Default Implementation

extension ReadableCodableStore {
    
    /// Retrieve first Object matching Filter
    ///
    /// - Parameter filter: The Filter
    /// - Returns: The matching Object
    /// - Throws: If retrieving fails
    public func first(where filter: (Object) -> Bool) throws -> Object? {
        // Return first matching object
        return try self.get(where: filter).first
    }
    
    /// Check if Object with Identifier exists
    ///
    /// - Parameter identifier: The Identifier
    /// - Returns: Boolean if Object exists
    public func exists(identifier: Object.ID) -> Bool {
        return (try? self.get(identifier: identifier)) != nil
    }
    
    /// Check if Object exists
    ///
    /// - Parameter object: The Object
    /// - Returns: Boolean if Object exists
    public func exists(_ object: Object) -> Bool {
        return self.exists(identifier: object.codableStoreIdentifierValue)
    }
    
}
