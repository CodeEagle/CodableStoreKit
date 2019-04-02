//
//  SaveableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - SaveableCodableStore

/// The SaveableCodableStore
public struct SaveableCodableStore<Storable: CodableStorable> {
    
    // MARK: Properties
    
    /// The save closure
    private let saveClosure: (Storable) throws -> Storable
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter store: The SaveableCodableStoreProtocol
    init<Store: SaveableCodableStoreProtocol>(_ store: Store) where Store.Storable == Storable {
        self.saveClosure = store.save
    }
    
}

// MARK: - SaveableCodableStoreProtocol

extension SaveableCodableStore: SaveableCodableStoreProtocol {
    
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
