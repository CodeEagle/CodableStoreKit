//
//  CodableStoreEngine.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStoreEngine

/// The CodableStoreEngine Typealias
public typealias CodableStoreEngine = WriteableCodableStoreEngine & ReadableCodableStoreEngine

// MARK: - WriteableCodableStoreEngine

/// The WriteableCodableStoreEngine Protocol
public protocol WriteableCodableStoreEngine {
    
    /// The associatedtype BaseCodableStoreable Object
    associatedtype Object: BaseCodableStoreable
    
    /// Save Object
    ///
    /// - Parameter object: The object to save
    /// - Returns: The saved object
    /// - Throws: If saving fails
    @discardableResult
    func save(_ object: Object) throws -> Object
    
    /// Delete Object via ID
    ///
    /// - Parameter identifier: The object identifier
    /// - Returns: The deleted object
    /// - Throws: If deleting fails
    @discardableResult
    func delete(identifier: Object.ID) throws -> Object
    
}

// MARK: - ReadableCodableStoreEngine

/// The ReadableCodableStoreEngine
public protocol ReadableCodableStoreEngine {
    
    /// The associatedtype BaseCodableStoreable Object
    associatedtype Object: BaseCodableStoreable
    
    /// Retrieve Object via ID
    ///
    /// - Parameter identifier: The identifier
    /// - Returns: The corresponding Object
    /// - Throws: If retrieving fails
    func get(identifier: Object.ID) throws -> Object
    
    /// Retrieve all Objects in Collection
    ///
    /// - Returns: The Objects in the Collection
    /// - Throws: If retrieving fails
    func getCollection() throws -> [Object]
    
}
