//
//  CodableStoreTableViewController.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

/// The CodableStoreTableViewController
open class CodableStoreTableViewController<Object: BaseCodableStoreable>: UITableViewController, CodableStoreControllerable {
    
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
    ///   - engine: The Engine. Default value `.fileSyste`
    ///   - style: The UITableViewStyle. Default value `.plain`
    public init(container: CodableStoreContainer = .default,
                engine: CodableStore<Object>.Engine = .fileSystem,
                style: UITableViewStyle = .plain) {
        self.codableStore = .init(container: container, engine: engine)
        self.codableStoreables = .init()
        self.subscriptionBag = .init()
        super.init(style: style)
        self.subscribeCollectionUpdates()
    }
    
    /// Initializer with Coder always returns nil
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: CodableStoreControllerable
    
    /// CodableStoreables did update with observe event
    ///
    /// - Parameter event: The ObserveEvent
    open func codableStoreablesDidUpdate(event: CodableStore<Object>.ObserveEvent) {
        // Reload Data
        self.tableView.reloadData()
    }
    
}

#endif
