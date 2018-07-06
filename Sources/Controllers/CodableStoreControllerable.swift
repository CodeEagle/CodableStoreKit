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
    
    /// The collection objects
    var objects: [Object] { get set }
    
    /// The SubscriptionBag
    var subscriptionBag: ObserverableCodableStoreSubscriptionBag { get }
    
    /// Object did update with event
    ///
    /// - Parameter event: The ObserveEvent
    func objectsDidUpdate(event: CodableStore<Object>.ObserveEvent)
    
}

// MARK: - CodableStoreControllerable Subscribe

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
            self?.objects = $0
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
            // Set objects
            weakSelf.objects = objects
            // Invoke objects did update with event
            weakSelf.objectsDidUpdate(event: event)
        }.disposed(
            by: self.subscriptionBag
        )
    }
    
    /// Retrieve Object at Index
    ///
    /// - Parameter index: The Index
    /// - Returns: Object at Index if index is contained in indices
    public func object(at index: Int) -> Object? {
        // Verfiy index is contained in indices
        guard self.objects.indices.contains(index) else {
            // Index out of bounds return nil
            return nil
        }
        // Return object at index
        return self.objects[index]
    }
    
}
