//
//  ObservableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 19.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - ObservableCodableStore

/// The ObservableCodableStore
public struct ObservableCodableStore<Storable: CodableStorable> {
    
    // MARK: Properties
    
    /// The Observe closure
    private let observeClosure: (Storable.Identifier, @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription
    
    /// The Observe Predicate closure
    private let observePredicateClosure: (
        @escaping (Storable) -> Bool,
        @escaping CodableStoreObserver<Storable>
    ) -> CodableStoreSubscription

    /// The Observe Collection closure
    private let observeCollectionClosure: (@escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription

    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter store: The ObservableCodableStoreProtocol
    init<Store: ObservableCodableStoreProtocol>(_ store: Store) where Store.Storable == Storable {
        self.observeClosure = store.observe
        self.observePredicateClosure = store.observe
        self.observeCollectionClosure = store.observeCollection
    }
    
}

// MARK: - ObservableCodableStoreProtocol

extension ObservableCodableStore: ObservableCodableStoreProtocol {
    
    /// Observe CodableStorable Identifier
    ///
    /// - Parameters:
    ///   - identifier: The CodableStorable Identifier
    ///   - observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    public func observe(identifier: Storable.Identifier,
                        _ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription {
        return self.observeClosure(identifier, observer)
    }
    
    /// Observer CodableStorable with predicate
    ///
    /// - Parameters:
    ///   - predicate: The Predicate
    ///   - observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    public func observe(where predicate: @escaping (Storable) -> Bool,
                        _ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription {
        return self.observePredicateClosure(predicate, observer)
    }
    
    /// Observe CodableStorable Collection
    ///
    /// - Parameter observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    public func observeCollection(_ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription {
        return self.observeCollectionClosure(observer)
    }
    
}
