//
//  WriteableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 05.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - WriteableCodableStore

/// The WriteableCodableStore Protocol
public protocol WriteableCodableStore: WriteableCodableStoreEngine {
    
    /// Delete Object
    ///
    /// - Parameter object: The objects to delete
    /// - Returns: The deleted object
    /// - Throws: If deleting fails
    @discardableResult
    func delete(_ object: Object) throws -> Object
    
    /// Save Objects
    ///
    /// - Parameter objects: The objects to save
    /// - Returns: Dictionary of saved objects with id and optional Error
    @discardableResult
    func save(_ objects: [Object]) -> [Object.ID: Error?]
    
    /// Delete Objects
    ///
    /// - Parameter objects: The objects to delete
    /// - Returns: Dictionary of deleted objects with id and optional Error
    @discardableResult
    func delete(_ objects: [Object]) -> [Object.ID: Error?]
    
    /// Delete Objects via IDs
    ///
    /// - Parameter identifier: The objects identifiers
    /// - Returns: Dictionary of deleted objects with id and optional Error
    @discardableResult
    func delete(identifiers: Object.ID...) -> [Object.ID: Error?]
    
    /// Delete the Collection
    ///
    /// - Returns: Dictionary of deleted objects with id and optional Error
    /// - Throws: If collection can't be retrieved
    @discardableResult
    func deleteCollection() throws -> [Object.ID: Error?]
    
}
