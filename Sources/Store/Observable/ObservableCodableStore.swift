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
    private let observeClosure: (Storable.Identifier, @escaping (CodableStoreObservedChange<Storable>) -> Void) -> CodableStoreSubscription
    
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
    
    /// Observe CodableStorable Identifier
    ///
    /// - Parameters:
    ///   - identifier: The CodableStorable Identifier
    ///   - observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    public func observe(_ identifier: Storable.Identifier,
                        _ observer: @escaping Observer) -> CodableStoreSubscription {
        return self.observeClosure(identifier, observer)
    }
    
}
