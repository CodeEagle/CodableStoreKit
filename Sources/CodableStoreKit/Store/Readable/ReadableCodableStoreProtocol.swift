//
//  ReadableCodableStoreProtocol.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - ReadableCodableStoreProtocol

/// The ReadableCodableStoreProtocol
public protocol ReadableCodableStoreProtocol {
    
    /// The Storable associatedtype which is constrainted to `CodableStorable`
    associatedtype Storable: CodableStorable
    
    /// Retrieve CodableStorable via Identifier
    ///
    /// - Parameter identifier: The Ientifier
    /// - Returns: The corresponding CodableStorable
    /// - Throws: If retrieving fails
    func get(identifier: Storable.Identifier) throws -> Storable
    
    /// Retrieve all CodableStorables in Collection
    ///
    /// - Returns: The CodableStorables in the Collection
    /// - Throws: If retrieving fails
    func getCollection() throws -> [Storable]
    
}

// MARK: - ReadableCodableStoreProtocol Convenience Functions

public extension ReadableCodableStoreProtocol {
    
    /// Retrieve CodableStorable via a given CodableStoreable
    ///
    /// - Parameter storable: The CodableStoreable
    /// - Returns: The corresponding CodableStorable
    /// - Throws: If retrieving fails
    func get(_ storable: Storable) throws -> Storable {
        return try self.get(identifier: storable.identifier)
    }
    
    /// Retrieve all CodableStorables in Collection which matches the given predicate
    ///
    /// - Parameter predicate: The predicate
    /// - Returns: The CodableStorables in Collection which matches the predicate
    /// - Throws: If retrieving fails
    func getCollection(where predicate: (Storable) -> Bool) throws -> [Storable] {
        return try self.getCollection().filter(predicate)
    }
    
    /// Retrieve first CodableStoreable in Collection which matches the given pedicate
    ///
    /// - Parameter predicate: The predicate
    /// - Returns: The first matching CodableStore
    /// - Throws: If retrieving fails
    func first(where predicate: (Storable) -> Bool) throws -> Storable? {
        return try self.getCollection().first(where: predicate)
    }
    
    /// Retrieve Bool if a CodableStorable exists
    ///
    /// - Parameter identifier: The CodableStorable Identifier
    /// - Returns: Bool if exists
    func exists(identifier: Storable.Identifier) -> Bool {
        return (try? self.get(identifier: identifier)) == nil
    }
    
    /// Retrieve Bool if a CodableStorable exists
    ///
    /// - Parameter storable: The CodableStorable
    /// - Returns: Bool if exists
    func exists(_ storable: Storable) -> Bool {
        return self.exists(identifier: storable.identifier)
    }
    
}
