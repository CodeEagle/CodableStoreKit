//
//  AnyWriteableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - AnyWriteableCodableStore (Type-Erasure)

/// The AnyWriteableCodableStore
public struct AnyWriteableCodableStore<Object: BaseCodableStoreable> {
    
    // MARK: Properties
    
    /// The save object closure
    private let saveObjectClosure: (Object) throws -> Object
    
    /// The delete identifier closure
    private let deleteIdentifierClosure: (Object.ID) throws -> Object
    
    /// The delete collection closure
    private let deleteCollectionClosure: () throws -> [Object.ID: Error?]
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter writeableCodableStore: The WriteableCodableStore
    init<W: WriteableCodableStore>(_ writeableCodableStore: W) where W.Object == Object {
        self.saveObjectClosure = {
            try writeableCodableStore.save($0)
        }
        self.deleteIdentifierClosure = {
            try writeableCodableStore.delete(identifier: $0)
        }
        self.deleteCollectionClosure = {
            try writeableCodableStore.deleteCollection()
        }
    }
    
}

// MARK: - WriteableCodableStore

extension AnyWriteableCodableStore: WriteableCodableStore {
    
    /// Save Object
    ///
    /// - Parameter object: The object to save
    /// - Returns: The saved object
    /// - Throws: If saving fails
    @discardableResult
    public func save(_ object: Object) throws -> Object {
        return try self.saveObjectClosure(object)
    }
    
    /// Delete Object via ID
    ///
    /// - Parameter identifier: The object identifier
    /// - Returns: The deleted object
    /// - Throws: If deleting fails
    @discardableResult
    public func delete(identifier: Object.ID) throws -> Object {
        return try self.deleteIdentifierClosure(identifier)
    }
    
    /// Delete the Collection
    ///
    /// - Returns: Dictionary of deleted objects with id and optional Error
    /// - Throws: If collection can't be retrieved
    @discardableResult
    public func deleteCollection() throws -> [Object.ID: Error?] {
        return try self.deleteCollectionClosure()
    }
    
}
