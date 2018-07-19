//
//  CodableStore+Copyable.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CopyableCodableStore

extension CodableStore: CopyableCodableStore {
    
    /// Copy the current Collection data to another CodableStore
    ///
    /// - Parameters:
    ///   - codableStore: The target CodableStore to insert data
    ///   - filter: The optional Filter
    /// - Returns: CodableStore Result Array
    /// - Throws: If copying fails
    @discardableResult
    public func copy(toStore codableStore: CodableStore<Object>,
                     where filter: ((Object) -> Bool)?) throws -> [CodableStore<Object>.Result] {
        // Try to retrieve current Collection
        let collection = try self.getCollection()
        // Try to save current collection in CodableStore
        return codableStore.save(collection)
    }
    
}
