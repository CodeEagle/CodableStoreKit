//
//  UserDefaultsCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStore

/// The CodableStore
public class CodableStore<Object: BaseCodableStoreable> {
    
    // MARK: Properties
    
    /// The Container
    let container: CodableStoreContainer
    
    /// The Engine
    let engine: AnyCodableStoreEngine<Object>
    
    /// The Observer
    let observer: AnyObserverableCodableStore<Object>
    
    // MARK: Initializer

    /// Designated Initializer
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer. Default value `Default Container`
    ///   - engine: The Engine. Default value `.fileSystem`
    public init(container: CodableStoreContainer = .init(),
                engine: Engine = .fileSystem) {
        self.container = container
        switch engine {
        case .fileSystem:
            self.engine = .init(FileManagerCodeableStoreEngine(container: container))
        case .inMemory:
            self.engine = .init(InMemoryCodableStoreEngine(container: container))
        case .custom(let engine):
            self.engine = .init(engine)
        }
        self.observer = ObserverStorage.sharedInstance.getObserver(objectType: Object.self)
    }
    
    /// Deinit
    deinit {
        /// Clear Observer for Object Type
        ObserverStorage
            .sharedInstance
            .clearObserveUsage(objectType: Object.self)
    }
    
}

// MARK: - CodableStore.Engine

public extension CodableStore {
    
    /// The Engine
    enum Engine {
        /// FileSystem
        case fileSystem
        /// InMemory
        case inMemory
        /// Supply custom CodableStoreEngine
        case custom(AnyCodableStoreEngine<Object>)
    }

}

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
        // Initialize result Dictionary
        var result: [Object.ID: Error?] = .init()
        // For each object
        for object in objects {
            do {
                // Delete object
                try self.delete(object)
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
    
    /// Delete Objects via IDs
    ///
    /// - Parameter identifier: The objects identifiers
    /// - Returns: Dictionary of deleted objects with id and optional Error
    @discardableResult
    public func delete(identifiers: Object.ID...) -> [Object.ID: Error?] {
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
    
    /// Delete the Collection
    ///
    /// - Returns: Dictionary of deleted objects with id and optional Error
    /// - Throws: If collection can't be retrieved
    @discardableResult
    public func deleteCollection() throws -> [Object.ID: Error?] {
        // Try to Retrieve Collection
        let collection = try self.getCollection()
        // Return self delete the collection
        return self.delete(collection)
    }
    
}

// MARK: - ReadableCodableStore

extension CodableStore: ReadableCodableStore {
    
    /// Retrieve Object via ID
    ///
    /// - Parameter identifier: The identifier
    /// - Returns: The corresponding Object
    /// - Throws: If retrieving fails
    public func get(identifier: Object.ID) throws -> Object {
        return try self.engine.get(identifier: identifier)
    }
    
    /// Retrieve all Objects in Collection
    ///
    /// - Returns: The Objects in the Collection
    /// - Throws: If retrieving fails
    public func getCollection() throws -> [Object] {
        return try self.engine.getCollection()
    }
    
    /// Retrieve Objects with Filter
    ///
    /// - Parameter filter: The Filter
    /// - Returns: An array of matching objects
    /// - Throws: If retrieving fails
    public func get(where filter: (Object) -> Bool) throws -> [Object] {
        // Return all objects matching the filter
        return try self.engine.getCollection().filter(filter)
    }
    
    /// Retrieve first Object matching Filter
    ///
    /// - Parameter filter: The Filter
    /// - Returns: The matching Object
    /// - Throws: If retrieving fails
    public func first(where filter: (Object) -> Bool) throws -> Object? {
        // Return first matching object
        return try self.get(where: filter).first
    }
    
    /// Check if Object with Identifier exists
    ///
    /// - Parameter identifier: The Identifier
    /// - Returns: Boolean if Object exists
    public func exists(identifier: Object.ID) -> Bool {
        do {
            // Try to retrieve object with identifier
            _ = try self.get(identifier: identifier)
            // Object exists
            return true
        } catch {
            // Object doesn't exists
            return false
        }
    }
    
    /// Check if Object exists
    ///
    /// - Parameter object: The Object
    /// - Returns: Boolean if Object exists
    public func exists(_ object: Object) -> Bool {
        return self.exists(identifier: object.codableStoreIdentifierValue)
    }
    
}

// MARK: - ObservableCodableStore

extension CodableStore: ObserverableCodableStore {
    
    /// The Observe Handler Typealias closure
    public typealias ObserveHandler = (CodableStore<Object>.ObserveEvent) -> Void
    
    /// Observe Object with Identifier
    ///
    /// - Parameters:
    ///   - identifier: The Object identifier to observe
    ///   - handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    public func observe(identifier: Object.ID,
                        handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription {
        return self.observer.observe(identifier: identifier, handler: handler)
    }
    
    /// Observe Object where filter matches
    ///
    /// - Parameters:
    ///   - filter: The Object Filter
    ///   - handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    public func observe(where filter: @escaping (Object) -> Bool,
                        handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription {
        return self.observer.observe(where: filter, handler: handler)
    }
    
}
