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
    private let subscriptions: Locked<[CodableStoreSubscription]>
    
    /// Bool if Bag is empty
    public var isEmpty: Bool {
        return self.subscriptions.value.isEmpty
    }
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter subscriptions: The CodableStoreSubscriptions. Default value `.init`
    public init(subscriptions: [CodableStoreSubscription] = .init()) {
        self.subscriptions = .init(subscriptions)
    }
    
    /// Deinit
    deinit {
        // Invalidate
        self.invalidate()
    }
    
}

// MARK: - Invalidate

public extension CodableStoreSubscriptionBag {
    
    /// Invalidate
    func invalidate() {
        // Invalidate each Subscription
        self.subscriptions.value.forEach { $0.invalidate() }
        // Remove all Subscriptions
        self.subscriptions.value.removeAll()
    }
    
}

// MARK: - Append

extension CodableStoreSubscriptionBag {
    
    /// Append CodableStoreSubscription
    ///
    /// - Parameter subscription: The CodableStoreSubscription
    func append(_ subscription: CodableStoreSubscription) {
        self.subscriptions.value.append(subscription)
    }
    
}
