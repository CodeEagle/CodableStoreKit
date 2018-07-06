//
//  CodableStoreViewController.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

/// The CodableStoreViewController
open class CodableStoreViewController<Object: BaseCodableStoreable>: UIViewController, CodableStoreControllerable {
    
    // MARK: Properties
    
    /// The CodableStore
    open var codableStore: CodableStore<Object>
    
    /// The collection objects
    open var objects: [Object]
    
    /// The SubscriptionBag
    open var subscriptionBag: ObserverableCodableStoreSubscriptionBag
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer. Default value `.default`
    ///   - engine: The Engine. Default value `.fileSystem`
    public init(container: CodableStoreContainer = .default,
                engine: CodableStore<Object>.Engine = .fileSystem) {
        self.codableStore = .init(container: container, engine: engine)
        self.objects = .init()
        self.subscriptionBag = .init()
        super.init(nibName: nil, bundle: nil)
        self.subscribeCollectionUpdates()
    }
    
    /// Initializer with Coder always returns nil
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: - CodableStoreControllerable
    
    /// Object did update with event
    ///
    /// - Parameter event: The ObserveEvent
    open func objectsDidUpdate(event: CodableStore<Object>.ObserveEvent) {}
    
}

#endif