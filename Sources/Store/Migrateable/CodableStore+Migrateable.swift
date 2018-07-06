//
//  CodableStore+Migrateable.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - MigrateableCodableStore

extension CodableStore: MigrateableCodableStore {
    
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
        // Try to retrieve current Collection
        let collection = try self.getCollection()
        // Initialize a CodableStore for current Collection with given Container in Engine
        let codableStore = CodableStore<Object>(container: container, engine: engine)
        // Try to save collection data
        return codableStore.save(collection)
    }
    
}
