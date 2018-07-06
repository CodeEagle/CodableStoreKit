//
//  AnyReadableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - AnyReadableCodableStore (Type-Erasure)

/// The AnyReadableCodableStore
public struct AnyReadableCodableStore<Object: BaseCodableStoreable> {
    
    // MARK: Properties
    
    /// The get object closure
    private let getClosure: ((Object) -> Bool) throws -> [Object]
    
    /// The get identifier closure
    private let getIdentifierClosure: (Object.ID) throws -> Object
    
    /// The get collection closure
    private let getCollectionClosure: () throws -> [Object]
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter readableCodableStore: The ReadableCodableStore
    init<R: ReadableCodableStore>(_ readableCodableStore: R) where R.Object == Object {
        self.getClosure = {
            try readableCodableStore.get(where: $0)
        }
        self.getIdentifierClosure = {
            try readableCodableStore.get(identifier: $0)
        }
        self.getCollectionClosure = {
            try readableCodableStore.getCollection()
        }
    }
    
}

// MARK: - ReadableCodableStore

extension AnyReadableCodableStore: ReadableCodableStore {
    
    /// Retrieve Object via ID
    ///
    /// - Parameter identifier: The identifier
    /// - Returns: The corresponding Object
    /// - Throws: If retrieving fails
    public func get(identifier: Object.ID) throws -> Object {
        return try self.getIdentifierClosure(identifier)
    }
    
    /// Retrieve all Objects in Collection
    ///
    /// - Returns: The Objects in the Collection
    /// - Throws: If retrieving fails
    public func getCollection() throws -> [Object] {
        return try self.getCollectionClosure()
    }
    
    /// Retrieve Objects with Filter
    ///
    /// - Parameter filter: The Filter
    /// - Returns: An array of matching objects
    /// - Throws: If retrieving fails
    public func get(where filter: (Object) -> Bool) throws -> [Object] {
        return try self.getClosure(filter)
    }

}
