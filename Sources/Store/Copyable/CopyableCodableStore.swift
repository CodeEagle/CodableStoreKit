//
//  CopyableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CopyableCodableStore

/// The CopyableCodableStore Protocol
public protocol CopyableCodableStore {
    
    /// The associatedtype BaseCodableStoreable Object
    associatedtype Object: BaseCodableStoreable
    
    /// Copy the current Collection data to another Container in a specific Engine
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer
    ///   - engine: The Engine
    ///   - filter: The optional Filter
    /// - Returns: Dictionary of saved objects with id and optional Error
    /// - Throws: If copying fails
    @discardableResult
    func copy(toContainer container: CodableStoreContainer,
              inEngine engine: CodableStore<Object>.Engine,
              where filter: ((Object) -> Bool)?) throws -> [Object.ID: Error?]
    
    /// Copy the current Collection data to another CodableStore
    ///
    /// - Parameters:
    ///   - codableStore: The target CodableStore to insert data
    ///   - filter: The optional Filter
    /// - Returns: Dictionary of saved objects with id and optional Error
    /// - Throws: If copying fails
    @discardableResult
    func copy(toStore codableStore: CodableStore<Object>,
              where filter: ((Object) -> Bool)?) throws -> [Object.ID: Error?]
    
}

// MARK: - CopyableCodableStore Default Implementation

extension CopyableCodableStore {
    
    /// Copy the current Collection data to another Container in a specific Engine
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer
    ///   - engine: The Engine
    ///   - filter: The optional Filter
    /// - Returns: Dictionary of saved objects with id and optional Error
    /// - Throws: If copying fails
    @discardableResult
    public func copy(toContainer container: CodableStoreContainer,
                     inEngine engine: CodableStore<Object>.Engine,
                     where filter: ((Object) -> Bool)?) throws -> [Object.ID: Error?] {
        // Initialize a CodableStore for current Collection with given Container in Engine
        let codableStore = CodableStore<Object>(container: container, engine: engine)
        // Return try to copy to CodableStore with optional filter
        return try self.copy(toStore: codableStore, where: filter)
    }
    
}
