//
//  CodableStore+Writeable.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - WriteableCodableStore

extension CodableStore: WriteableCodableStore {
    
    /// Save Object
    ///
    /// - Parameter object: The object to save
    /// - Returns: The saved object
    /// - Throws: If saving fails
    @discardableResult
    public func save(_ object: Object) throws -> Object {
        // Try to save Object in Engine
        let object =  try self.engine.save(object)
        // Emit Observer with save event
        self.observer.next(object, event: .saved(object, self.container))
        // Return saved object
        return object
    }
    
    /// Delete Object via ID
    ///
    /// - Parameter identifier: The object identifier
    /// - Returns: The deleted object
    /// - Throws: If deleting fails
    @discardableResult
    public func delete(identifier: Object.ID) throws -> Object {
        // Try to delete Object in Engine via Identifier
        let object = try self.engine.delete(identifier: identifier)
        // Emit observer with delete event
        self.observer.next(object, event: .deleted(object, self.container))
        // Return deleted object
        return object
    }
    
    /// Delete the Collection
    ///
    /// - Returns: CodableStore Result Array
    /// - Throws: If collection can't be retrieved
    @discardableResult
    public func deleteCollection() throws -> [CodableStore<Object>.Result] {
        // Try to Retrieve Collection
        let collection = try self.getCollection()
        // Return self delete the collection
        return self.delete(collection)
    }
    
}
