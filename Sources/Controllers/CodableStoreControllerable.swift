//
//  CodableStoreControllerable.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStoreControllerable

/// The CodableStoreControllerable Protocol
public protocol CodableStoreControllerable: class {
    
    /// The associatedtype BaseCodableStoreable Object
    associatedtype Object: BaseCodableStoreable
    
    /// The CodableStore
    var codableStore: CodableStore<Object> { get }
    
    /// The CodableStoreables
    var codableStoreables: [Object] { get set }
    
    /// The SubscriptionBag
    var subscriptionBag: ObserverableCodableStoreSubscriptionBag { get }
    
    /// CodableStoreables will update with observe event
    ///
    /// - Parameter event: The ObserveEvent
    func codableStoreablesWillUpdate(event: CodableStore<Object>.ObserveEvent)
    
    /// CodableStoreables did update with observe event
    ///
    /// - Parameter event: The ObserveEvent
    func codableStoreablesDidUpdate(event: CodableStore<Object>.ObserveEvent)
    
}

// MARK: - CodableStoreControllerable Default Implementation

extension CodableStoreControllerable {
    
    /// CodableStoreables will update with observe event
    ///
    /// - Parameter event: The ObserveEvent
    public func codableStoreablesWillUpdate(event: CodableStore<Object>.ObserveEvent) {}
    
    /// CodableStoreables did update with observe event
    ///
    /// - Parameter event: The ObserveEvent
    public func codableStoreablesDidUpdate(event: CodableStore<Object>.ObserveEvent) {}
    
}

// MARK: - CodableStoreControllerable Funtions

extension CodableStoreControllerable {
    
    /// Subscribe to Collection Updates
    func subscribeCollectionUpdates() {
        // Check if SubscriptionBag is not empty
        if !self.subscriptionBag.isEmpty {
            // Return out of function
            return
        }
        // Initialize objects with Collection
        (try? self.codableStore.getCollection()).flatMap { [weak self] in
            self?.codableStoreables = $0
        }
        // Observe Collection and disposed by SubscriptionBag
        self.codableStore.observeCollection { [weak self] event in
            // Verify self is available
            guard let weakSelf = self else {
                // Self is unavailable
                return
            }
            // Retrieve Collection
            guard let objects = try? weakSelf.codableStore.getCollection() else {
                // Collection is unavailable
                return
            }
            // Invoke CodableStoreables will update
            weakSelf.codableStoreablesWillUpdate(event: event)
            // Set CodableStoreables
            weakSelf.codableStoreables = objects
            // Invoke objects did update with event
            weakSelf.codableStoreablesDidUpdate(event: event)
        }.disposed(
            by: self.subscriptionBag
        )
    }
    
    /// Retrieve CodableStoreable at Index
    ///
    /// - Parameter index: The Index
    /// - Returns: CodableStoreable at Index if index is contained in indices
    public func codableStoreable(at index: Int) -> Object? {
        // Verfiy index is contained in indices
        guard self.codableStoreables.indices.contains(index) else {
            // Index out of bounds return nil
            return nil
        }
        // Return CodableStoreable at index
        return self.codableStoreables[index]
    }
    
}
