//
//  CodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - CodableStore

/// The CodableStore
public final class CodableStore<Storable: CodableStorable> {
    
    // MARK: Properties
    
    /// The Engine
    let engine: CodableStoreEngine
    
    /// The CodableStoreContainer
    public let container: CodableStoreContainer
    
    /// The CodableStoreManager
    let manager: CodableStoreManager
    
    // MARK: Initializer

    /// Designated Initializer
    ///
    /// - Parameters:
    ///   - engine: The CodableStoreEngine. Default value `nil`
    ///   - container: The CodableStoreContainer. Default value `.default`
    ///   - manager: The CodableStoreManager. Default value `DefaultCodableStoreManager.sharedInstance`
    public init(engine: CodableStoreEngine? = nil,
                container: CodableStoreContainer = .default,
                manager: CodableStoreManager = DefaultCodableStoreManager.sharedInstance) {
        self.engine = engine ?? manager.provideEngine(for: Storable.self, in: container)
        self.container = container
        self.manager = manager
    }
    
}

// MARK: - SaveableCodableStoreProtocol

extension CodableStore: SaveableCodableStoreProtocol {
    
    /// Save CodableStorable
    ///
    /// - Parameter storable: The CodableStorable to save
    /// - Returns: The saved CodableStorable
    /// - Throws: If saving fails
    @discardableResult
    public func save(_ storable: Storable) throws -> Storable {
        // Save Storable in Container
        let storable: Storable = try self.engine.save(storable, in: self.container)
        // Emit saved with Storable and Container
        self.manager.emit(.saved(storable: storable, container: self.container))
        // Return saved Storable
        return storable
    }
    
}

// MARK: - DeletableCodableStoreProtocol

extension CodableStore: DeletableCodableStoreProtocol {
    
    /// Delete CodableStorable via Identifier
    ///
    /// - Parameter identifier: The CodableStorable Identifier
    /// - Returns: The deleted CodableStorable
    /// - Throws: If deleting fails
    @discardableResult
    public func delete(_ identifier: Storable.Identifier) throws -> Storable {
        // Delete Storable in Container
        let storable: Storable = try self.engine.delete(identifier, in: self.container)
        // Emit deleted with Storable and Container
        self.manager.emit(.deleted(storable: storable, container: self.container))
        // Return deleted Storable
        return storable
    }
    
    /// Delete all CodableStorables in Collection
    ///
    /// - Returns: The deleted CodableStorables
    @discardableResult
    public func deleteCollection() throws -> [Storable] {
        // Delete Collection in Container
        let storables: [Storable] = try self.engine.deleteCollection(in: self.container)
        // For each Storable
        for storable in storables {
            // Emit deleted with Storable and Container
            self.manager.emit(.deleted(storable: storable, container: self.container))
        }
        // Return deleted Storables
        return storables
    }
    
}

// MARK: - ReadableCodableStoreProtocol

extension CodableStore: ReadableCodableStoreProtocol {
    
    /// Retrieve CodableStorable via Identifier
    ///
    /// - Parameter identifier: The Ientifier
    /// - Returns: The corresponding CodableStorable
    /// - Throws: If retrieving fails
    public func get(identifier: Storable.Identifier) throws -> Storable {
        return try self.engine.get(identifier: identifier, in: self.container)
    }
    
    /// Retrieve all CodableStorables in Collection
    ///
    /// - Returns: The CodableStorables in the Collection
    /// - Throws: If retrieving fails
    public func getCollection() throws -> [Storable] {
        return try self.engine.getCollection(in: self.container)
    }
    
}

// MARK: - ObservableCodableStoreProtocol

extension CodableStore: ObservableCodableStoreProtocol {
    
    /// Observe CodableStorable with Intent
    ///
    /// - Parameters:
    ///   - intent: The CodableStoreObserverIntent
    ///   - observer: The CodableStoreObserver
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    public func observe(with intent: CodableStoreObserverIntent<Storable>,
                        _ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription {
        // Add Observer with Identifier Intent and return Subscription
        return self.manager.subscribe(with: intent, observer)
    }
    
}
