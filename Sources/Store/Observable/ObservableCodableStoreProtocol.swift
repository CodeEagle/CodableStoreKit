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
    
    /// The Observer Typealias
    typealias Observer = (CodableStoreObservedChange<Storable>) -> Void
    
    /// Observe CodableStorable Identifier
    ///
    /// - Parameters:
    ///   - identifier: The CodableStorable Identifier
    ///   - observer: The Observer
    /// - Returns: The CodableStoreSubscription
    @discardableResult
    func observe(_ identifier: Storable.Identifier,
                 _ observer: @escaping Observer) -> CodableStoreSubscription
    
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
                 _ observer: @escaping Observer) -> CodableStoreSubscription {
        return self.observe(storable.identifier, observer)
    }
    
}
