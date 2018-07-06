//
//  AnyMigrateableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - AnyMigrateableCodableStore (Type-Erasure)

/// The AnyMigrateableCodableStore
public struct AnyMigrateableCodableStore<Object: BaseCodableStoreable> {
    
    // MARK: Properties
    
    /// The migrate closure
    private let migrateClosure: (CodableStoreContainer, CodableStore<Object>.Engine) throws -> [Object.ID: Error?]
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter migrateableCodableStore: The MigrateableCodableStore
    init<M: MigrateableCodableStore>(_ migrateableCodableStore: M) where M.Object == Object {
        self.migrateClosure = {
            try migrateableCodableStore.migrate(toContainer: $0, inEngine: $1)
        }
    }
    
}

// MARK: - MigrateableCodableStore

extension AnyMigrateableCodableStore: MigrateableCodableStore {
    
    /// Migrate current Collection data to another Container in a specific Engine
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer
    ///   - engine: The Engine
    /// - Returns: Dictionary of saved objects with id and optional Error
    /// - Throws: If migration fails
    @discardableResult
    public func migrate(toContainer container: CodableStoreContainer,
                        inEngine engine: CodableStore<Object>.Engine) throws -> [Object.ID: Error?] {
        return try self.migrateClosure(container, engine)
    }
    
}
