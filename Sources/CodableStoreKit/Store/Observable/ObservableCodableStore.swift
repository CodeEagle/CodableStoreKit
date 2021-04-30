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
    private let observeClosure: (CodableStoreObserverIntent<Storable>, @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription

    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter store: The ObservableCodableStoreProtocol
    init<Store: ObservableCodableStoreProtocol>(_ store: Store) where Store.Storable == Storable {
        self.observeClosure = store.observe
    }
    
}

// MARK: - ObservableCodableStoreProtocol

extension ObservableCodableStore: ObservableCodableStoreProtocol {
    
    /// Observe CodableStorable with Intent
    ///
    /// - Parameters:
    ///   - intent: The CodableStoreObserverIntent
    ///   - observer: The CodableStoreObserver
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    public func observe(with intent: CodableStoreObserverIntent<Storable>,
                        _ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription {
        return self.observeClosure(intent, observer)
    }
    
}
