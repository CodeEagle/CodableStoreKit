//
//  AnyCodableStoreEngine.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - AnyCodableStoreEngine (Type-Erasure)

/// The Type-Erased CodableStoreEngine Wrapper
struct AnyCodableStoreEngine<Object: BaseCodableStoreable>: InitializableCodableStoreEngine {
    
    // MARK: Properties
    
    /// The Container
    var container: CodableStoreContainer {
        return self.containerClosure()
    }
    
    /// The Container Closure
    private let containerClosure: () -> CodableStoreContainer
    
    /// The save closure
    private let saveClosure: (Object) throws -> Object
    
    /// The delete with identifier closure
    private let deleteIdentifierClosure: (Object.ID) throws -> Object
    
    /// The get closure
    private let getClosure: (Object.ID) throws -> Object
    
    /// The get collection closure
    private let getCollectionClosure: () throws -> [Object]
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter engine: The CodableStoreEngine
    init<T: CodableStoreEngine>(_ engine: T) where T.Object == Object {
        self.containerClosure = {
            engine.container
        }
        self.saveClosure = {
            try engine.save($0)
        }
        self.deleteIdentifierClosure = {
            try engine.delete(identifier: $0)
        }
        self.getClosure = {
            try engine.get(identifier: $0)
        }
        self.getCollectionClosure = {
            try engine.getCollection()
        }
    }
    
    /// ⚠️ Don't init AnyCodableStoreEngine with a Container.
    /// Use initializer with a CodableStoreEngine instead
    @available(*, deprecated, message: "⚠️ Unable to init with Container. Use the initializer with a CodableStoreEngine")
    init(container: CodableStoreContainer) {
        fatalError(
            "⚠️ AnyCodableStoreEngine can't be initialized with Container. Init with CodableStoreEngine"
        )
    }
    
}

// MARK: - WriteableCodableStoreEngine

extension AnyCodableStoreEngine: WriteableCodableStoreEngine {
    
    /// Save Object
    ///
    /// - Parameter object: The object to save
    /// - Returns: The saved object
    /// - Throws: If saving fails
    @discardableResult
    func save(_ object: Object) throws -> Object {
        return try self.saveClosure(object)
    }
    
    /// Delete Object via ID
    ///
    /// - Parameter identifier: The object identifier
    /// - Returns: The deleted object
    /// - Throws: If deleting fails
    @discardableResult
    func delete(identifier: Object.ID) throws -> Object {
        return try self.deleteIdentifierClosure(identifier)
    }
    
}

// MARK: - ReadbleCodableStoreEngine

extension AnyCodableStoreEngine: ReadableCodableStoreEngine {
    
    /// Retrieve Object via ID
    ///
    /// - Parameter identifier: The identifier
    /// - Returns: The corresponding Object
    /// - Throws: If retrieving fails
    func get(identifier: Object.ID) throws -> Object {
        return try self.getClosure(identifier)
    }
    
    /// Retrieve all Objects in Collection
    ///
    /// - Returns: The Objects in the Collection
    /// - Throws: If retrieving fails
    func getCollection() throws -> [Object] {
        return try self.getCollectionClosure()
    }
    
}
