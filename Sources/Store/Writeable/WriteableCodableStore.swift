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
    func delete(identifiers: [Object.ID]) -> [Object.ID: Error?]
    
    /// Delete the Collection
    ///
    /// - Returns: Dictionary of deleted objects with id and optional Error
    /// - Throws: If collection can't be retrieved
    @discardableResult
    func deleteCollection() throws -> [Object.ID: Error?]
    
}

// MARK: - WriteableCodableStore Default Implementation

extension WriteableCodableStore {
    
    /// Save Objects
    ///
    /// - Parameter objects: The objects to save
    /// - Returns: Dictionary of saved objects with id and optional Error
    @discardableResult
    public func save(_ objects: [Object]) -> [Object.ID: Error?] {
        // Initialize result Dictionary
        var result: [Object.ID: Error?] = .init()
        // For each object
        for object in objects {
            do {
                // Try to save object
                try self.save(object)
                // Set identifier with no error
                result[object.codableStoreIdentifierValue] = nil
            } catch {
                // Set identifier with error
                result[object.codableStoreIdentifierValue] = error
            }
        }
        // Return result Dictionary
        return result
    }
    
    /// Delete Object
    ///
    /// - Parameter object: The objects to delete
    /// - Returns: The deleted object
    /// - Throws: If deleting fails
    @discardableResult
    public func delete(_ object: Object) throws -> Object {
        // Try to Delete Object via Object Identifier
        return try self.delete(identifier: object.codableStoreIdentifierValue)
    }
    
    /// Delete Objects
    ///
    /// - Parameter objects: The objects to delete
    /// - Returns: Dictionary of deleted objects with id and optional Error
    @discardableResult
    public func delete(_ objects: [Object]) -> [Object.ID: Error?] {
        // Delete with object identifiers
        return self.delete(identifiers: objects.map { $0.codableStoreIdentifierValue })
    }
    
    /// Delete Objects via IDs
    ///
    /// - Parameter identifier: The objects identifiers
    /// - Returns: Dictionary of deleted objects with id and optional Error
    @discardableResult
    public func delete(identifiers: [Object.ID]) -> [Object.ID: Error?] {
        // Initialize result Dictionary
        var result: [Object.ID: Error?] = .init()
        // For each identifier
        for identifier in identifiers {
            do {
                // Try to delete identifier
                try self.delete(identifier: identifier)
                // Set identifier with no error
                result[identifier] = nil
            } catch {
                // Set identifier with error
                result[identifier] = error
            }
        }
        // Return result Dictionary
        return result
    }
    
}
