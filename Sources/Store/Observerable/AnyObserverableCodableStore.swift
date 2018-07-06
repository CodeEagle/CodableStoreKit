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
public class AnyObserverableCodableStore<Object: BaseCodableStoreable> {
    
    // MARK: Properties
    
    /// The Observe Handler Typealias closure
    public typealias ObserveHandler = (CodableStore<Object>.ObserveEvent) -> Void
    
    /// The Thread-Safe Locked Observable Handlers
    let store: Locked<[String: (mode: HandlerObserveMode, handler: ObserveHandler)]>
    
    /// Boolean if Stores are empty
    var isEmpty: Bool {
        return self.store.value.isEmpty
    }
    
    // MARK: Initializer
    
    /// Designated Initializer
    init() {
        self.store = .init(.init())
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

// MARK: - Observer API

extension AnyObserverableCodableStore {
    
    /// Emit Next ObservableCodableStoreEvent with Identifier
    ///
    /// - Parameters:
    ///   - identifier: The Identifier
    ///   - event: The Event
    func next(identifier: Object.ID, event: CodableStore<Object>.ObserveEvent) {
        // Emit Event to all matching IdentifierStore Handlers
        self.store.value.values
            // Filter values
            .filter {
                // Switch on mode
                switch $0.mode {
                case .identifier(let objectIdentifier):
                    // Return if identifier matches
                    return objectIdentifier == identifier
                case .filter(let filter):
                    // Return if filter matches
                    return filter(event.object)
                }
            }
            // Map to Handler
            .map { $0.handler }
            // For Each Handler
            .forEach { handler in
                // Dispatch on Main Thread
                DispatchQueue.main.async {
                    // Invoke Handler with Event
                    handler(event)
                }
        }
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
    public func observe(identifier: Object.ID,
                        handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription {
        // Handle Observe with identifier and return Subscription
        return self.handleObserve(
            mode: .identifier(identifier),
            handler: handler
        )
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
        // Handle Observe with filter and return Subscription
        return self.handleObserve(
            mode: .filter(filter),
            handler: handler
        )
    }
    
    /// Handle an Observe with an either an Identifier or Filter
    ///
    /// - Parameters:
    ///   - mode: The HandlerObserveMode
    ///   - handler: The Observe Handler
    /// - Returns: Observable Subscription
    func handleObserve(mode: HandlerObserveMode,
                       handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription {
        // Initialize Handler Identifier
        let handlerIdentifier = self.getHandlerIdentifier()
        // Set handler to store with mode
        self.store.value[handlerIdentifier] = (mode, handler)
        // Return Subscription
        return Subscription(dispose: { [weak self] in
            // Remove Handler from Store
            self?.store.value.removeValue(forKey: handlerIdentifier)
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
        
        // MARK: API
        
        /// Unsubscribe Observable
        func unsubscribe() {
            self.dispose()
        }
        
    }
    
}

// MARK: - HandlerObserveMode

extension AnyObserverableCodableStore {
    
    /// The HandlerObserveMode
    enum HandlerObserveMode {
        /// Identifier
        case identifier(Object.ID)
        /// Filter
        case filter((Object) -> Bool)
    }
    
}
