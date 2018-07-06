//
//  ObserverableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 05.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - ObserverableCodableStore

/// The ObserverableCodableStore Protocol
public protocol ObserverableCodableStore {
    
    /// The associatedtype BaseCodableStoreable Object
    associatedtype Object: BaseCodableStoreable
    
    /// The Observe Handler Typealias closure
    typealias ObserveHandler = (CodableStore<Object>.ObserveEvent) -> Void
    
    /// Observe Object with Identifier
    ///
    /// - Parameters:
    ///   - identifier: The Object identifier to observe
    ///   - handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    func observe(identifier: Object.ID,
                 handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription
    
    /// Observe Object
    ///
    /// - Parameters:
    ///   - object: The Object to observe
    ///   - handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    func observe(_ object: Object,
                 handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription
    
    /// Observe Object where filter matches
    ///
    /// - Parameters:
    ///   - filter: The Object Filter
    ///   - handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    func observe(where filter: @escaping (Object) -> Bool,
                 handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription
    
    /// Observe the Collection
    ///
    /// - Parameter handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    func observeCollection(handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription
    
}

// MARK: - ObserverableCodableStore Default Implementation

extension ObserverableCodableStore {
    
    /// Observe Object
    ///
    /// - Parameters:
    ///   - object: The Object to observe
    ///   - handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    public func observe(_ object: Object,
                        handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription {
        // Return observe with identifier and handler
        return self.observe(identifier: object.codableStoreIdentifierValue, handler: handler)
    }
    
    /// Observe the Collection
    ///
    /// - Parameter handler: The Observe Handler
    /// - Returns: Observable Subscription
    @discardableResult
    public func observeCollection(handler: @escaping ObserveHandler) -> ObserverableCodableStoreSubscription {
        // Return observe with filter which always evaluates true
        return self.observe(where: { _ in true }, handler: handler)
    }
    
}

// MARK: - ObserverableCodableStoreSubscription

/// The ObserverableCodableStoreSubscription Protocol
public protocol ObserverableCodableStoreSubscription {
    
    /// Unsubcribe Observable
    func unsubscribe()
    
    /// Dipose Subscription via an ObserverableCodableStoreSubscriptionBag
    ///
    /// - Parameter subscriptionBag: The ObserverableCodableStoreSubscriptionBag
    func disposed(by subscriptionBag: ObserverableCodableStoreSubscriptionBag)
    
}

// MARK: - ObserverableCodableStoreSubscription Default Implementation

extension ObserverableCodableStoreSubscription {
    
    /// Dipose Subscription via an ObserverableCodableStoreSubscriptionBag
    ///
    /// - Parameter subscriptionBag: The ObserverableCodableStoreSubscriptionBags
    func disposed(by subscriptionBag: ObserverableCodableStoreSubscriptionBag) {
        // Add self to SubscriptionBag
        subscriptionBag.add(self)
    }
    
}

// MARK: - ObserverableCodableStoreSubscriptionBag

/// The ObserverableCodableStoreSubscriptionBag
public class ObserverableCodableStoreSubscriptionBag {
    
    // MARK: Properties
    
    /// The Subscriptions
    private let subscriptions: Locked<[ObserverableCodableStoreSubscription]>
    
    /// Boolean if SubscriptionBag is empty
    public var isEmpty: Bool {
        return self.subscriptions.value.isEmpty
    }
    
    // MARK: Initializer
    
    /// Designated Initializer
    public init() {
        self.subscriptions = .init(.init())
    }
    
    /// Deinit
    deinit {
        // Dispose each Subscription
        self.subscriptions.value.forEach {
            $0.unsubscribe()
        }
    }
    
    // MARK: Public API
    
    /// Add Subscription
    ///
    /// - Parameter subscription: The Subscriptions
    public func add(_ subscription: ObserverableCodableStoreSubscription) {
        // Append Subscription
        self.subscriptions.value.append(subscription)
    }
    
}
