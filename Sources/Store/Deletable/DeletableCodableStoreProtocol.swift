//
//  DeletableCodableStoreProtocol.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - DeletableCodableStoreProtocol

/// The DeletableCodableStoreProtocol
public protocol DeletableCodableStoreProtocol {
    
    /// The Storable associatedtype which is constrainted to `CodableStorable`
    associatedtype Storable: CodableStorable
    
    /// Delete CodableStorable via Identifier
    ///
    /// - Parameter identifier: The CodableStorable Identifier
    /// - Returns: The deleted CodableStorable
    /// - Throws: If deleting fails
    @discardableResult
    func delete(_ identifier: Storable.Identifier) throws -> Storable
    
    /// Delete all CodableStorables in Collection
    ///
    /// - Returns: The deleted CodableStorables
    @discardableResult
    func deleteCollection() throws -> [Storable]
    
}

// MARK: - DeletableCodableStoreProtocol Convenience Functions

public extension DeletableCodableStoreProtocol {
    
    /// Delete CodableStorable
    ///
    /// - Parameter storable: The CodableStorable to delete
    /// - Returns: The deleted CodableStorable
    /// - Throws: If deleting fails
    @discardableResult
    func delete(_ storable: Storable) throws -> Storable {
        return try self.delete(storable[keyPath: Storable.codableStoreIdentifier])
    }
    
    /// Delete CodableStorable Array
    ///
    /// - Parameter storables: The CodableStorables to delete
    /// - Returns: The deleted CodableStorables
    /// - Throws: If deleting fails
    @discardableResult
    func delete(_ storables: [Storable]) throws -> [Storable] {
        return try storables.map(self.delete)
    }
    
    /// Delete CodableStorables via Identifiers
    ///
    /// - Parameter identifiers: The CodableStorable Identifiers to delete
    /// - Returns: The deleted CodableStorables
    /// - Throws: If deleting fails
    @discardableResult
    func delete(_ identifiers: [Storable.Identifier]) throws -> [Storable] {
        return try identifiers.map(self.delete)
    }
    
}
