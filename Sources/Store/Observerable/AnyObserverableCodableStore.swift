//
//  AnyObserverableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 05.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - AnyObserverableCodableStore

/// The AnyObservableCodableStore 
class AnyObserverableCodableStore<Object: BaseCodableStoreable> {
    
    // MARK: Properties
    
    /// The Thread-Safe Locked Observable Handlers based on Object Identifier
    let identifierStore: Locked<[String: (id: Object.ID, handler: (CodableStore<Object>.ObserveEvent) -> Void)]>
    
    /// The Thread-Safe Locked Observable Handlers based on Object Filter
    let filterStore: Locked<[String: (filter: (Object) -> Bool, handler: (CodableStore<Object>.ObserveEvent) -> Void)]>
    
    /// Boolean if Stores are empty
    var isEmpty: Bool {
        return self.identifierStore.value.isEmpty && self.filterStore.value.isEmpty
    }
    
    // MARK: Initializer
    
    /// Designated Initializer
    init() {
        self.identifierStore = Locked(.init())
        self.filterStore = .init(.init())
    }
    
    // MARK: Handler Identifier Generation
    
    /// Retrieve a Handler Identifier
    ///
    /// - Returns: Handler Identifier
    func getHandlerIdentifier() -> String {
        // Return UUIDv4 String
        return UUID().uuidString
    }
    
}

// MARK: Observer API

extension AnyObserverableCodableStore {
    
    /// Emit Next ObservableCodableStoreEvent with Identifier
    ///
    /// - Parameters:
    ///   - identifier: The Identifier
    ///   - event: The Event
    func next(identifier: Object.ID, event: CodableStore<Object>.ObserveEvent) {
        // Emit Event to all matching IdentifierStore Handlers
        self.identifierStore.value.values
            .filter { $0.id == identifier }
            .forEach { $0.handler(event) }
        // Emit Event to all matching FilterStore Handlers
        self.filterStore.value.values
            .filter { $0.filter(event.object) }
            .forEach { $0.handler(event) }
    }
    
    /// Emit next ObservableCodableStoreEvent with Object
    ///
    /// - Parameters:
    ///   - object: The Object
    ///   - event: The Event
    func next(_ object: Object, event: CodableStore<Object>.ObserveEvent) {
        // Invoke next with identifier
        self.next(
            identifier: object.codableStoreIdentifierValue,
            event: event
        )
    }
    
}

// MARK: - ObserverableCodableStore

extension AnyObserverableCodableStore: ObserverableCodableStore {
    
    /// Observe Object with Identifier
    ///
    /// - Parameters:
    ///   - identifier: The Object identifier to observe
    ///   - handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    func observe(identifier: Object.ID,
                 handler: @escaping (CodableStore<Object>.ObserveEvent) -> Void) -> ObserverableCodableStoreSubscription {
        // Initialize Handler Identifier
        let handlerIdentifier = self.getHandlerIdentifier()
        // Set handler to store
        self.identifierStore.value[handlerIdentifier] = (identifier, handler)
        // Return Subscription
        return Subscription(dispose: { [weak self] in
            // Remove Handler from Store
            self?.identifierStore.value.removeValue(forKey: handlerIdentifier)
        })
    }
    
    /// Observe Object where filter matches
    ///
    /// - Parameters:
    ///   - filter: The Object Filter
    ///   - handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    func observe(where filter: @escaping (Object) -> Bool,
                 handler: @escaping (CodableStore<Object>.ObserveEvent) -> Void) -> ObserverableCodableStoreSubscription {
        // Initialize Handler Identifier
        let handlerIdentifier = self.getHandlerIdentifier()
        // Set handler to store
        self.filterStore.value[handlerIdentifier] = (filter, handler)
        // Return Subscription
        return Subscription(dispose: { [weak self] in
            // Remove Handler from Store
            self?.filterStore.value.removeValue(forKey: handlerIdentifier)
        })
    }
    
}

// MARK: - Subscription

extension AnyObserverableCodableStore {
    
    /// The Observable Subscription
    class Subscription: ObserverableCodableStoreSubscription {
        
        // MARK: Properties
        
        /// The Dispose Closure
        let dispose: () -> Void
        
        // MARK: Initializer
        
        /// Designated Initializer with Dispose Closure
        ///
        /// - Parameter dispose: The Dispose Closure
        init(dispose: @escaping () -> Void) {
            self.dispose = dispose
        }
        
        /// Unsubscribe Observable
        func unsubscribe() {
            self.dispose()
        }
        
    }
    
}
