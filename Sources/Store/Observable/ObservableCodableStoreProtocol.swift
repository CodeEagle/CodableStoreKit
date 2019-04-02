//
//  ObservableCodableStoreProtocol.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 19.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - ObservableCodableStoreProtocol

/// The ObservableCodableStoreProtocol
public protocol ObservableCodableStoreProtocol {
    
    /// The Storable associatedtype which is constrainted to `CodableStorable`
    associatedtype Storable: CodableStorable
    
    /// Observe CodableStorable with Intent
    ///
    /// - Parameters:
    ///   - intent: The CodableStoreObserverIntent
    ///   - observer: The CodableStoreObserver
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    func observe(with intent: CodableStoreObserverIntent<Storable>,
                 _ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription
    
}

// MARK: - ObservableCodableStoreProtocol Convenience Functions

public extension ObservableCodableStoreProtocol {
    
    /// Observe CodableStorable Identifier
    ///
    /// - Parameters:
    ///   - identifier: The CodableStorable Identifier
    ///   - observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    func observe(identifier: Storable.Identifier,
                 _ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription {
        return self.observe(with: .identifier(identifier), observer)
    }
    
    /// Observe CodableStorable
    ///
    /// - Parameters:
    ///   - storable: The CodableStorable
    ///   - observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    func observe(_ storable: Storable,
                 _ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription {
        return self.observe(identifier: storable.identifier, observer)
    }
    
    /// Observer CodableStorable with predicate
    ///
    /// - Parameters:
    ///   - predicate: The Predicate
    ///   - observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    func observe(where predicate: @escaping (Storable) -> Bool,
                 _ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription {
        return self.observe(with: .predicate(predicate), observer)
    }
    
    /// Observe CodableStorable Collection
    ///
    /// - Parameter observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    func observeCollection(_ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription {
        return self.observe(with: .all, observer)
    }
    
}
