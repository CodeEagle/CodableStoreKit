//
//  WritableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 02.04.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - WritableCodableStore

/// The WritableCodableStore
public struct WritableCodableStore<Storable: CodableStorable> {
    
    // MARK: Properties
    
    /// The save closure
    private let saveClosure: (Storable) throws -> Storable
    
    /// The delete closure
    private let deleteClosure: (Storable.Identifier) throws -> Storable
    
    /// The deleteCollection closure
    private let deleteCollectionClosure: () throws -> [Storable]
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter store: The SaveableCodableStoreProtocol
    init<Store: WritableCodableStoreProtocol>(_ store: Store) where Store.Storable == Storable {
        self.saveClosure = store.save
        self.deleteClosure = store.delete
        self.deleteCollectionClosure = store.deleteCollection
    }
    
}

// MARK: - SaveableCodableStoreProtocol

extension WritableCodableStore: SaveableCodableStoreProtocol {
    
    /// Save CodableStorable
    ///
    /// - Parameter Storable: The CodableStorable to save
    /// - Returns: The saved CodableStorable
    /// - Throws: If saving fails
    @discardableResult
    public func save(_ storable: Storable) throws -> Storable {
        return try self.saveClosure(storable)
    }
    
}

// MARK: - DeletableCodableStoreProtocol

extension WritableCodableStore: DeletableCodableStoreProtocol {
    
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
