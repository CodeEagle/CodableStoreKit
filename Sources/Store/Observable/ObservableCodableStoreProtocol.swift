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
    
    /// Observe CodableStorable Identifier
    ///
    /// - Parameters:
    ///   - identifier: The CodableStorable Identifier
    ///   - observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    func observe(identifier: Storable.Identifier,
                 _ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription
    
    /// Observer CodableStorable with predicate
    ///
    /// - Parameters:
    ///   - predicate: The Predicate
    ///   - observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    func observe(where predicate: @escaping (Storable) -> Bool,
                 _ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription
    
    /// Observe CodableStorable Collection
    ///
    /// - Parameter observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    func observeCollection(_ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription
    
}

// MARK: - ObservableCodableStoreProtocol Convenience Functions

extension ObservableCodableStoreProtocol {
    
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
    
}
