//
//  CodableStore+Observable.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

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
