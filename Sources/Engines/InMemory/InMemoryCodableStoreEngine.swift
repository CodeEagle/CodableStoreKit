//
//  InMemoryCodableStoreEngine.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - InMemoryCodableStoreEngine

/// The InMemoryCodableStoreEngine
class InMemoryCodableStoreEngine<Object: BaseCodableStoreable> {

    /// The CodableStoreContaner
    let container: CodableStoreContainer
    
    /// Designated Initializer
    ///
    /// - Parameter container: The CodableStoreContainer
    init(container: CodableStoreContainer = .default) {
        self.container = container
    }
    
}

// MARK: - EngineError

extension InMemoryCodableStoreEngine {
    
    /// The EngineError
    enum EngineError: Error {
        /// Object not Found
        case objectNotFound(Object)
        /// Identifier not found
        case identifierNotFound(Object.ID)
    }
    
}

// MARK: - Keys

extension InMemoryCodableStoreEngine {
    
    /// The Collection Key
    var collectionKey: String {
        return "\(self.container).\(Object.codableStoreCollectionName)"
    }
    
    /// Retrieve Key for Object
    ///
    /// - Parameter object: The Object
    /// - Returns: The Key
    func getKey(_ object: Object) -> String {
        return self.getKey(object.codableStoreIdentifierValue)
    }
    
    /// Retrieve Key for Identifier
    ///
    /// - Parameter identifier: The Identifier
    /// - Returns: The Key
    func getKey(_ identifier: Object.ID) -> String {
        return "\(self.collectionKey).\(identifier)"
    }
    
}

// MARK: - WriteableCodableStoreEngine

extension InMemoryCodableStoreEngine: WriteableCodableStoreEngine {
    
    /// Save Object
    ///
    /// - Parameter object: The object to save
    /// - Returns: The saved object
    /// - Throws: If saving fails
    @discardableResult
    func save(_ object: Object) throws -> Object {
        SharedMemory.sharedInstance.memory.value[self.getKey(object)] = object
        return object
    }
    
    /// Delete Object via ID
    ///
    /// - Parameter identifier: The object identifier
    /// - Returns: The deleted object
    /// - Throws: If deleting fails
    @discardableResult
    func delete(identifier: Object.ID) throws -> Object {
        guard let deletedObject = SharedMemory.sharedInstance.memory.value
            .removeValue(forKey: self.getKey(identifier)) as? Object else {
                throw EngineError.identifierNotFound(identifier)
        }
        return deletedObject
    }
    
}

// MARK: - ReadableCodableStoreEngine

extension InMemoryCodableStoreEngine: ReadableCodableStoreEngine {
    
    /// Retrieve Object via ID
    ///
    /// - Parameter identifier: The identifier
    /// - Returns: The corresponding Object
    /// - Throws: If retrieving fails
    func get(identifier: Object.ID) throws -> Object {
        guard let object = SharedMemory.sharedInstance.memory.value[self.getKey(identifier)] as? Object else {
            throw EngineError.identifierNotFound(identifier)
        }
        return object
    }
    
    /// Retrieve all Objects in Collection
    ///
    /// - Returns: The Objects in the Collection
    /// - Throws: If retrieving fails
    func getCollection() throws -> [Object] {
        return SharedMemory.sharedInstance.memory.value.keys
            .filter { $0.contains(self.collectionKey) }
            .compactMap { SharedMemory.sharedInstance.memory.value[$0] as? Object }
    }
    
}

// MARK: - SharedMemory

/// The SharedMemory
private class SharedMemory {
    
    /// The SharedInstance
    static var sharedInstance = SharedMemory()
    
    /// The Memory
    let memory: Locked<[String: Codable]>
    
    /// The Private Initializer
    private init() {
        self.memory = .init(.init())
    }
    
}
