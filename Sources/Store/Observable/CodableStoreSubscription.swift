//
//  CodableStoreSubscription.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 19.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - CodableStoreSubscription

/// The CodableStoreSubscription
public final class CodableStoreSubscription {
    
    // MARK: Properties
    
    /// The Invalidation closure
    var invalidation: (() -> Void)?
    
    /// Bool if Subscription is invalidated
    public var isInvalidated: Bool {
        return self.invalidation == nil
    }
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter invalidation: The Invalidation closure
    init(_ invalidation: @escaping () -> Void) {
        self.invalidation = invalidation
    }
    
    // MARK: - API
    
    /// Invalidate Subscription
    public func invalidate() {
        // Invoke Invalidation
        self.invalidation?()
        // Clear Invalidation
        self.invalidation = nil
    }
    
    /// Invalidate by CodableStoreSubscriptionBag
    ///
    /// - Parameter bag: The CodableStoreSubscriptionBag
    public func invalidate(by bag: CodableStoreSubscriptionBag) {
        // Append self to Subscription of CodableStoreSubscriptionBag
        bag.subscriptions.append(self)
    }
    
}
