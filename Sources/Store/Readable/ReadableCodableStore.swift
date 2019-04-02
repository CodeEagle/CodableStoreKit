//
//  ReadableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - ReadableCodableStore

/// The ReadableCodableStore
public struct ReadableCodableStore<Storable: CodableStorable> {
    
    // MARK: Properties
    
    /// The get closure
    private let getClosure: (Storable.Identifier) throws -> Storable
    
    /// The getCollection closure
    private let getCollectionClosure: () throws -> [Storable]
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter store: The ReadableCodableStoreProtocol
    init<Store: ReadableCodableStoreProtocol>(_ store: Store) where Store.Storable == Storable {
        self.getClosure = store.get
        self.getCollectionClosure = store.getCollection
    }
    
}

// MARK: - ReadableCodableStoreProtocol

extension ReadableCodableStore: ReadableCodableStoreProtocol {
    
    /// Retrieve CodableStorable via Identifier
    ///
    /// - Parameter identifier: The Ientifier
    /// - Returns: The corresponding CodableStorable
    /// - Throws: If retrieving fails
    public func get(identifier: Storable.Identifier) throws -> Storable {
        return try self.getClosure(identifier)
    }
    
    /// Retrieve all CodableStorables in Collection
    ///
    /// - Returns: The CodableStorables in the Collection
    /// - Throws: If retrieving fails
    public func getCollection() throws -> [Storable] {
        return try self.getCollectionClosure()
    }
    
}
