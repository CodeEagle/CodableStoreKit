//
//  CodableStoreSubscriptionBag.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 19.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - CodableStoreSubscriptionBag

/// The CodableStoreSubscriptionBag
public final class CodableStoreSubscriptionBag {
    
    // MARK: Properties
    
    /// The CodableStoreSubscriptions
    var subscriptions: [CodableStoreSubscription]
    
    /// Bool if Bag is empty
    public var isEmpty: Bool {
        return self.subscriptions.isEmpty
    }
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter subscriptions: The CodableStoreSubscriptions. Default value `.init`
    public init(subscriptions: [CodableStoreSubscription] = .init()) {
        self.subscriptions = subscriptions
    }
    
    /// Deinit
    deinit {
        // Invalidate
        self.invalidate()
    }
    
    /// Invalidate
    public func invalidate() {
        // Invalidate each Subscription
        self.subscriptions.forEach { $0.invalidate() }
        // Remove all Subscriptions
        self.subscriptions.removeAll()
    }
    
}
