//
//  CodableStore+Readable.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - ReadableCodableStore

extension CodableStore: ReadableCodableStore {
    
    /// Retrieve Object via ID
    ///
    /// - Parameter identifier: The identifier
    /// - Returns: The corresponding Object
    /// - Throws: If retrieving fails
    public func get(identifier: Object.ID) throws -> Object {
        return try self.engine.get(identifier: identifier)
    }
    
    /// Retrieve all Objects in Collection
    ///
    /// - Returns: The Objects in the Collection
    /// - Throws: If retrieving fails
    public func getCollection() throws -> [Object] {
        return try self.engine.getCollection()
    }
    
    /// Retrieve Objects with Filter
    ///
    /// - Parameter filter: The Filter
    /// - Returns: An array of matching objects
    /// - Throws: If retrieving fails
    public func get(where filter: (Object) -> Bool) throws -> [Object] {
        // Return all objects matching the filter
        return try self.engine.getCollection().filter(filter)
    }
    
}
