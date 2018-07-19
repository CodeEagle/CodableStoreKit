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
    /// - Returns: CodableStore Result Array
    @discardableResult
    func save(_ objects: [Object]) -> [CodableStore<Object>.Result]
    
    /// Delete Objects
    ///
    /// - Parameter objects: The objects to delete
    /// - Returns: CodableStore Result Array
    @discardableResult
    func delete(_ objects: [Object]) -> [CodableStore<Object>.Result]
    
    /// Delete Objects via IDs
    ///
    /// - Parameter identifier: The objects identifiers
    /// - Returns: CodableStore Result Array
    @discardableResult
    func delete(identifiers: [Object.ID]) -> [CodableStore<Object>.Result]
    
    /// Delete the Collection
    ///
    /// - Returns: CodableStore Result Array
    /// - Throws: If collection can't be retrieved
    @discardableResult
    func deleteCollection() throws -> [CodableStore<Object>.Result]
    
}

// MARK: - WriteableCodableStore Default Implementation

extension WriteableCodableStore {
    
    /// Save Objects
    ///
    /// - Parameter objects: The objects to save
    /// - Returns: CodableStore Result Array
    @discardableResult
    public func save(_ objects: [Object]) -> [CodableStore<Object>.Result] {
        return objects.map {
            do {
                // Try to save and return success
                return .success(try self.save($0))
            } catch {
                // Return failure with identifier and error
                return .failure($0.codableStoreIdentifierValue, error)
            }
        }
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
    /// - Returns: CodableStore Result Array
    @discardableResult
    public func delete(_ objects: [Object]) -> [CodableStore<Object>.Result] {
        // Delete with object identifiers
        return self.delete(identifiers: objects.map { $0.codableStoreIdentifierValue })
    }
    
    /// Delete Objects via IDs
    ///
    /// - Parameter identifier: The objects identifiers
    /// - Returns: CodableStore Result Array
    @discardableResult
    public func delete(identifiers: [Object.ID]) -> [CodableStore<Object>.Result] {
        return identifiers.map {
            do {
                // Try to delete and return success
                return .success(try self.delete(identifier: $0))
            } catch {
                // Return failure with identifier and error
                return .failure($0, error)
            }
        }
    }
    
}
