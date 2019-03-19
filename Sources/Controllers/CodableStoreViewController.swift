//
//  CodableStoreViewController.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 19.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

// MARK: - CodableStoreViewController

/// The CodableStoreViewController
open class CodableStoreViewController<Storable: CodableStorable>: UIViewController {
    
    // MARK: Properties
    
    /// The CodableStore
    open var codableStore: CodableStore<Storable>
    
    /// The CodableStorables
    open var codableStorables: [Storable]

    /// The CodableStoreSubscriptionBag
    open var subscriptionBag: CodableStoreSubscriptionBag
    
    /// The CodableStoreObservedChange Event
    open var observationEvent: CodableStoreObservedChange<Storable>?
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameters:
    ///   - engine: The optional CodableStoreEngine. Default value `nil` which will use the default CodableStoreEngine
    ///   - container: The CodableStoreContainer. Default value `default`
    public init(engine: CodableStoreEngine? = nil, container: CodableStoreContainer = .default) {
        // Check if an Engine is available
        if let engine = engine {
            // Initialize CodableStore with Engine and Container
            self.codableStore = .init(engine: engine, container: container)
        } else {
            // Initialize CodableStore with Container
            self.codableStore = .init(container: container)
        }
        // Initialize CodableStoreable Array
        self.codableStorables = .init()
        // Initialize CodableStoreSubscriptionBag
        self.subscriptionBag = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Initializer with Coder always return nil
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: View-Lifecycle
    
    /// View did load
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Reload CodableStorables
        self.reloadCodableStorables()
        // Observe Collection
        self.codableStore.observeCollection { [weak self] event in
            // Set Observation event
            self?.observationEvent = event
            // Reload CodableStorables
            self?.reloadCodableStorables()
        }.disposed(by: self.subscriptionBag)
    }
    
    // MARK: CodableStoreViewController-Lifecycle
    
    /// CodableStorables will update
    ///
    /// - Parameters:
    ///   - oldValue: The current CodableStorables
    ///   - newValue: The new CodableStorables
    open func codableStorablesWillUpdate(from oldValue: [Storable], to newValue: [Storable]) {}
    
    /// CodableStorables did update
    ///
    /// - Parameters:
    ///   - event: The CodableStoreObservedChange Event
    ///   - codableStorables: The updated CodableStorables
    open func codableStorablesDidUpdate(_ codableStorables: [Storable]) {}
    
    /// CodableStorables did failed to update
    ///
    /// - Parameters:
    ///   - event: The CodableStoreObservedChange Event
    ///   - error: The Error
    open func codableStorablesUpdateFailed(_ error: Error) {}
    
}

// MARK: - Reload CodableStorables

public extension CodableStoreViewController {
    
    /// Reload CodableStorables
    final func reloadCodableStorables() {
        // Declare CodableStorable Array
        let codableStorables: [Storable]
        do {
            // Initialize CodableStorable Array
            codableStorables = try self.codableStore.getCollection()
        } catch {
            // CodableStoreables update failed with error
            self.codableStorablesUpdateFailed(error)
            // Return out of functio
            return
        }
        // Invoke will update lifecycle
        self.codableStorablesWillUpdate(from: self.codableStorables, to: codableStorables)
        // Set CodableStorables
        self.codableStorables = codableStorables
        // Invoke did update lifecycle
        self.codableStorablesDidUpdate(self.codableStorables)
    }
    
}

#endif
