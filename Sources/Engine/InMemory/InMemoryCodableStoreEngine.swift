//
//  InMemoryCodableStoreEngine.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - InMemoryCodableStoreEngine

/// The InMemoryCodableStoreEngine
public final class InMemoryCodableStoreEngine {
    
    // MARK: Typealias
    
    /// The Memory Typealis
    public typealias Memory = [CodableStoreContainer: [AnyHashable: Any]]
    
    public typealias MemoryV2 = [CodableStoreContainer: [AnyHashable: [AnyHashable: Any]]]
    
    // MARK: Properties
    
    /// The ThreadSafe Locked Memory
    let memory: Locked<Memory>
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter memory: The Memory. Default value `init`
    public init(memory: Memory = .init()) {
        self.memory = .init(memory)
    }
    
}

// MARK: - CodableStoreEngine

extension InMemoryCodableStoreEngine: CodableStoreEngine {
    
    /// Save CodableStorable
    ///
    /// - Parameter storable: The CodableStorable to save
    /// - Returns: The saved CodableStorable
    /// - Throws: If saving fails
    @discardableResult
    public func save<Storable: CodableStorable>(_ storable: Storable,
                                                in container: CodableStoreContainer) throws -> Storable {
        if self.memory.value[container] == nil {
            self.memory.value[container] = .init()
        }
        self.memory.value[container]?[storable.identifier] = storable
        return storable
    }
    
    /// Delete CodableStorable via Identifier
    ///
    /// - Parameter identifier: The CodableStorable Identifier
    /// - Returns: The deleted CodableStorable
    /// - Throws: If deleting fails
    @discardableResult
    public func delete<Storable: CodableStorable>(_ identifier: Storable.Identifier,
                                                  in container: CodableStoreContainer) throws -> Storable {
        guard let storable = self.memory.value[container]?[identifier.stringRepresentation] as? Storable else {
            throw CodableStoreEngineError<Storable>.notFound(identifier: identifier)
        }
        self.memory.value[container]?.removeValue(forKey: identifier.stringRepresentation)
        return storable
    }
    
    /// Delete all CodableStorables in Collection
    ///
    /// - Returns: The deleted CodableStorables
    @discardableResult
    public func deleteCollection<Storable: CodableStorable>(in container: CodableStoreContainer) throws -> [Storable] {
        let storables: [Storable] = try self.getCollection(in: container)
        self.memory.value[container]?.removeAll()
        return storables
    }
    
    /// Retrieve CodableStorable via Identifier
    ///
    /// - Parameter identifier: The Ientifier
    /// - Returns: The corresponding CodableStorable
    /// - Throws: If retrieving fails
    public func get<Storable: CodableStorable>(_ identifier: Storable.Identifier,
                                               in container: CodableStoreContainer) throws -> Storable {
        guard let storable = self.memory.value[container]?[identifier.stringRepresentation] as? Storable else {
            throw CodableStoreEngineError<Storable>.notFound(identifier: identifier)
        }
        return storable
    }
    
    /// Retrieve all CodableStorables in Collection
    ///
    /// - Returns: The CodableStorables in the Collection
    /// - Throws: If retrieving fails
    public func getCollection<Storable: CodableStorable>(in container: CodableStoreContainer) throws -> [Storable] {
        guard let storablesDictionary = self.memory.value[container], let storables = Array(storablesDictionary.values) as? [Storable] else {
            throw CodableStoreEngineError<Storable>.collectionNotFound(container: container)
        }
        return storables
    }
    
}

// MARK: - Locked

extension InMemoryCodableStoreEngine {
    
    /// ThreadSafe Locked Value
    final class Locked<Value> {
        
        /// The Lock fastest option (https://gist.github.com/steipete/36350a8a60693d440954b95ea6cbbafc)
        private var lock = os_unfair_lock()
        
        /// The internal Value
        private var internalValue: Value
        
        /// The Value
        var value: Value {
            get {
                os_unfair_lock_lock(&self.lock)
                defer {
                    os_unfair_lock_unlock(&self.lock)
                }
                return self.internalValue
            }
            set {
                os_unfair_lock_lock(&self.lock)
                defer {
                    os_unfair_lock_unlock(&self.lock)
                }
                self.internalValue = newValue
            }
        }
        
        /// Default initializer with Value
        ///
        /// - Parameter value: The Value
        init(_ value: Value) {
            self.internalValue = value
        }
        
        /// Mutate value
        ///
        /// - Parameter changes: The changes closure
        func mutate(_ changes: (inout Value) -> Void) {
            os_unfair_lock_lock(&self.lock)
            defer {
                os_unfair_lock_unlock(&self.lock)
            }
            changes(&self.internalValue)
        }
        
    }
    
}
