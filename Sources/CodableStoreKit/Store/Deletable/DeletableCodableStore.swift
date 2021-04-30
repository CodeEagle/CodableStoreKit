//
//  DeletableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - DeletableCodableStore

/// The DeletableCodableStore
public struct DeletableCodableStore<Storable: CodableStorable> {
    
    // MARK: Properties
    
    /// The delete closure
    private let deleteClosure: (Storable.Identifier) throws -> Storable
    
    /// The deleteCollection closure
    private let deleteCollectionClosure: () throws -> [Storable]
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter store: The DeletableCodableStoreProtocol
    init<Store: DeletableCodableStoreProtocol>(_ store: Store) where Store.Storable == Storable {
        self.deleteClosure = store.delete
        self.deleteCollectionClosure = store.deleteCollection
    }
    
}

// MARK: - DeletableCodableStoreProtocol

extension DeletableCodableStore: DeletableCodableStoreProtocol {
    
    /// Delete CodableStorable via Identifier
    ///
    /// - Parameter identifier: The CodableStorable Identifier
    /// - Returns: The deleted CodableStorable
    /// - Throws: If deleting fails
    @discardableResult
    public func delete(_ identifier: Storable.Identifier) throws -> Storable {
        return try self.deleteClosure(identifier)
    }
    
    /// Delete all CodableStorables in Collection
    ///
    /// - Returns: The deleted CodableStorables
    @discardableResult
    public func deleteCollection() throws -> [Storable] {
        return try self.deleteCollectionClosure()
    }
    
}
