//
//  CodableStoreCollectionViewController.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

// swiftlint:disable line_length
/// The CodableStoreCollectionViewController
open class CodableStoreCollectionViewController<Object: BaseCodableStoreable>: UICollectionViewController, CodableStoreControllerable {
// swiftlint:enable line_length
    
    // MARK: Properties
    
    /// The CodableStore
    open var codableStore: CodableStore<Object>
    
    /// The CodableStoreables
    open var codableStoreables: [Object]
    
    /// The SubscriptionBag
    open var subscriptionBag: ObserverableCodableStoreSubscriptionBag
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer. Default value `.default`
    ///   - engine: The Engine. Default value `.fileSystem`
    ///   - layout: The UICollectionViewLayout. Default value `UICollectionViewFlowLayout`
    public init(container: CodableStoreContainer = .default,
                engine: CodableStore<Object>.Engine = .fileSystem,
                layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        self.codableStore = .init(container: container, engine: engine)
        if let codableStoreables = try? self.codableStore.getCollection() {
            self.codableStoreables = codableStoreables
        } else {
            self.codableStoreables = .init()
        }
        self.codableStoreables = .init()
        self.subscriptionBag = .init()
        super.init(collectionViewLayout: layout)
        self.subscribeCollectionUpdates()
    }
    
    /// Initializer with Coder always returns nil
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: CodableStoreControllerable
    
    /// CodableStoreables will update with observe event
    ///
    /// - Parameters:
    ///   - event: The ObserveEvent
    ///   - codableStoreables: The current CodableStoreables before update
    open func codableStoreablesWillUpdate(event: CodableStore<Object>.ObserveEvent,
                                          codableStoreables: [Object]) {}
    
    /// CodableStoreables did update with observe event
    ///
    /// - Parameters:
    ///   - event: The ObserveEvent
    ///   - codableStoreables: The updated CodableStoreables
    open func codableStoreablesDidUpdate(event: CodableStore<Object>.ObserveEvent,
                                         codableStoreables: [Object]) {
        // Reload Data
        self.collectionView?.reloadData()
    }
    
}

#endif