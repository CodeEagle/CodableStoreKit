//
//  CodableStoreable.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStoreable

/// The CodableStoreable Protocol
public protocol CodableStoreable: BaseCodableStoreable {}

// MARK: - Private Container Builder

private extension CodableStoreable {
    
    /// Build CodableStore with Container and Engine
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer
    ///   - engine: The Engine
    /// - Returns: CodableStore
    private static func codableStore(_ container: CodableStoreContainer,
                                     _ engine: CodableStore<Self>.Engine) -> CodableStore<Self> {
        return .init(container: container, engine: engine)
    }
    
}

// MARK: - Writeable Convenience Functions

public extension CodableStoreable {
    
    /// Save Object
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer. Default value `.init`
    ///   - engine: The Engine. Default value `.fileSystem`
    /// - Returns: The saved object
    /// - Throws: If saving fails
    @discardableResult
    func save(container: CodableStoreContainer = .default,
              engine: CodableStore<Self>.Engine = .fileSystem) throws -> Self {
        return try Self.codableStore(container, engine).save(self)
    }
    
    /// Delete Object
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer. Default value `.init`
    ///   - engine: The Engine. Default value `.fileSystem`
    /// - Returns: The deleted object
    /// - Throws: If deleting fails
    @discardableResult
    func delete(container: CodableStoreContainer = .default,
                engine: CodableStore<Self>.Engine = .fileSystem) throws -> Self {
        return try Self.codableStore(container, engine).delete(self)
    }
    
}

// MARK: - Readable Convenience Functions

public extension CodableStoreable {
    
    /// Retrieve Object via Identifier
    ///
    /// - Parameters:
    ///   - identifier: The Identifier
    ///   - container: The CodableStoreContainer. Default value `.init`
    ///   - engine: The Engine. Default value `.fileSystem`
    /// - Returns: The retrieved object
    /// - Throws: If retrieving fails
    static func get(identifier: Self.ID,
                    container: CodableStoreContainer = .default,
                    engine: CodableStore<Self>.Engine = .fileSystem) throws -> Self {
        return try Self.codableStore(container, engine).get(identifier: identifier)
    }
    
    /// Retrieve all Objects in Collection
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer. Default value `.init`
    ///   - engine: The Engine. Default value `.fileSystem`
    /// - Returns: The retrieved Objects
    /// - Throws: If retrieving fails
    static func getCollection(container: CodableStoreContainer = .default,
                              engine: CodableStore<Self>.Engine = .fileSystem) throws -> [Self] {
        return try Self.codableStore(container, engine).getCollection()
    }
    
    /// Check if Object exists
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer. Default value `.init`
    ///   - engine: The Engine. Default value `.fileSystem`
    /// - Returns: Boolean if Object exists
    func exists(container: CodableStoreContainer = .default,
                engine: CodableStore<Self>.Engine = .fileSystem) -> Bool {
        return Self.codableStore(container, engine).exists(self)
    }
    
    /// Check if Object with Identifer exists
    ///
    /// - Parameters:
    ///   - identifier: The Identifier
    ///   - container: The CodableStoreContainer. Default value `.init`
    ///   - engine: The Engine. Default value `.fileSystem`
    /// - Returns: Boolean if Object exists
    static func exists(identifier: Self.ID,
                       container: CodableStoreContainer = .default,
                       engine: CodableStore<Self>.Engine = .fileSystem) -> Bool {
        return Self.codableStore(container, engine).exists(identifier: identifier)
    }
    
}

// MARK: - Observable Convenience Functions

public extension CodableStoreable {
    
    /// The Observe Handler Typealias closure
    typealias ObserveHandler = (CodableStore<Self>.ObserveEvent) -> Void
    
    /// Observe Object with Identifier
    ///
    /// - Parameters:
    ///   - identifier: The Object identifier to observe
    ///   - handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    static func observe(identifier: Self.ID,
                        handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription {
        return ObserverStorage
            .sharedInstance
            .getObserver(objectType: Self.self)
            .observe(identifier: identifier, handler: handler)
    }
    
    /// Observe Object
    ///
    /// - Parameters:
    ///   - object: The Object to observe
    ///   - handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    func observe(handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription {
        return ObserverStorage
            .sharedInstance
            .getObserver(objectType: Self.self)
            .observe(self, handler: handler)
    }
    
    /// Observe Object where filter matches
    ///
    /// - Parameters:
    ///   - filter: The Object Filter
    ///   - handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    static func observe(where filter: @escaping (Self) -> Bool,
                        handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription {
        return ObserverStorage
            .sharedInstance
            .getObserver(objectType: Self.self)
            .observe(where: filter, handler: handler)
    }
    
    /// Observe the Collection
    ///
    /// - Parameter handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    static func observeCollection(handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription {
        // Return observe with filter which always evaluates true
        return self.observe(where: { _ in true }, handler: handler)
    }
    
}

// MARK: - Copyable Convenience Functions

public extension CodableStoreable {
    
    /// Copy the CodableStoreable to another Container and Engine
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer
    ///   - engine: The Engine
    /// - Returns: The copied CodableStoreable
    /// - Throws: If copying fails
    @discardableResult
    func copy(toContainer container: CodableStoreContainer,
              inEngine engine: CodableStore<Self>.Engine) throws -> Self {
        return try Self.codableStore(container, engine).save(self)
    }
    
}

// MARK: - CodableStoreable Array Convenience Functions

extension Array where Element: CodableStoreable {
    
    /// Save Objects in Array
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer. Default value `.init`
    ///   - engine: The Engine. Default value `.fileSystem`
    /// - Returns: CodableStore Result Array
    @discardableResult
    func save(container: CodableStoreContainer,
              engine: CodableStore<Element>.Engine = .fileSystem) -> [CodableStore<Element>.Result] {
        return CodableStore(container: container, engine: engine).save(self)
    }
    
    /// Delete Objets in Array
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer. Default value `.init`
    ///   - engine: The Engine. Default value `.fileSystem`
    /// - Returns: CodableStore Result Array
    @discardableResult
    func delete(container: CodableStoreContainer,
                engine: CodableStore<Element>.Engine = .fileSystem) -> [CodableStore<Element>.Result] {
        return CodableStore(container: container, engine: engine).delete(self)
    }
    
}
