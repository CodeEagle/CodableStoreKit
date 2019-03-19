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
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter container: The CodableStoreContainer. Default value `.default`
    public init(container: CodableStoreContainer = .default) {
        self.engine = CodableStoreManager.engineProvider(Storable.self, container)
        self.container = container
    }
    
    /// Designated Initializer
    ///
    /// - Parameters:
    ///   - engine: The CodableStoreEngine
    ///   - container: The CodableStoreContainer. Default value `.default`
    public init(engine: CodableStoreEngine,
                container: CodableStoreContainer = .default) {
        self.engine = engine
        self.container = container
    }
    
}

// MARK: - Access-Control CodableStores

public extension CodableStore {
    
    /// The SaveableCodableStore
    var saveable: SaveableCodableStore<Storable> {
        return .init(self)
    }
    
    /// The DeletableCodableStore
    var deletable: DeletableCodableStore<Storable> {
        return .init(self)
    }
    
    /// The ReadableCodableStore
    var readable: ReadableCodableStore<Storable> {
        return .init(self)
    }
    
    /// The ObservableCodableStore
    var observable: ObservableCodableStore<Storable> {
        return .init(self)
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
        // Save Storable
        let storable: Storable = try self.engine.save(storable, in: self.container)
        CodableStoreManager.emit(
            type: Storable.self,
            .saved(storable: storable, container: self.container)
        )
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
        let storable: Storable = try self.engine.delete(identifier, in: self.container)
        CodableStoreManager.emit(
            type: Storable.self,
            .deleted(storable: storable, container: self.container)
        )
        return storable
    }
    
    /// Delete all CodableStorables in Collection
    ///
    /// - Returns: The deleted CodableStorables
    @discardableResult
    public func deleteCollection() throws -> [Storable] {
        let storables: [Storable] = try self.engine.deleteCollection(in: self.container)
        for storable in storables {
            CodableStoreManager.emit(
                type: Storable.self,
                .deleted(storable: storable, container: self.container)
            )
        }
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
    public func get(_ identifier: Storable.Identifier) throws -> Storable {
        return try self.engine.get(identifier, in: self.container)
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
    
    /// Observe CodableStorable Identifier
    ///
    /// - Parameters:
    ///   - identifier: The CodableStorable Identifier
    ///   - observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    public func observe(_ identifier: Storable.Identifier,
                        _ observer: @escaping Observer) -> CodableStoreSubscription {
        // Initialize a Key
        let key = UUID().uuidString
        // Store Observer for Key
        CodableStoreManager.observers.value[key] = (identifier.stringRepresentation, observer)
        // Return CodableStoreSubscription
        return CodableStoreSubscription {
            // Remove Observer for Key
            CodableStoreManager.observers.value.removeValue(forKey: key)
        }
    }
    
}
