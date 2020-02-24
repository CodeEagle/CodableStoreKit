//
//  CodableStoreNotificationCenter.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 21.11.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation
import UIKit

// MARK: - CodableStoreNotificationCenter

/// The CodableStoreNotificationCenter
open class CodableStoreNotificationCenter {
    
    // MARK: Static Properties
    
    /// The default shared instance of CodableStoreNotificationCenter
    public static let `default` = CodableStoreNotificationCenter()
    
    // MARK: Properties
    
    /// The Observations
    open var observations: [(Any) -> Bool] = .init()
    
    // MARK: Initializer
    
    /// Designated Initializer
    public init() {}
    
    // MARK: Observe
    
    /// Observe all Events on any CodableStore
    /// - Parameters:
    ///   - object: The Object to observe on
    ///   - observer: The Observer
    open func observeAll<Object: AnyObject>(
        on object: Object,
        observer: @escaping () -> Void
    ) {
        // Append Observation
        self.observations.append { [weak object] _ in
            // Verify Object is still available
            guard object != nil else {
                // Object isn't available return false
                // To indicate that the observation can be removed
                return false
            }
            // Invoke Observer
            observer()
            // Return true
            return true
        }
    }
    
    /// Observe CodableStore Event
    /// - Parameters:
    ///   - object: The Object to observe on
    ///   - storableType: The Storable Type. Default value `Storable.self`
    ///   - container: The optional CodableStoreContainer that should match. Default value `nil`
    ///   - observer: The Observer
    open func observe<Object: AnyObject, Storable: CodableStorable>(
        on object: Object,
        storableType: Storable.Type = Storable.self,
        in container: CodableStoreContainer? = nil,
        _ observer: @escaping (CodableStore<Storable>.Event) -> Void
    ) {
        // Append Observation
        self.observations.append { [weak object] event in
            // Verify Object is still available
            guard object != nil else {
                // Object isn't available return false
                // To indicate that the observation can be removed
                return false
            }
            // Verify Event matches the Storable type
            guard let event = event as? CodableStore<Storable>.Event else {
                // Otherwise return true as the Storable type
                // doesn't match the current one
                return true
            }
            // Check if a Container is available and the Event Container is not equal to it
            if let container = container, event.container != container {
                // Return true as the Containers doesn't match
                return true
            }
            // Invoke Observer with Event
            observer(event)
            // Return true
            return true
        }
    }
    
    // MARK: Emit
    
    /// Emit CodableStore  Event
    /// - Parameters:
    ///   - storableType: The Storable Type. Default value `Storable.self`
    ///   - event: The CodableStore  Event that should be emitted
    open func emit<Storable: CodableStorable>(
        storableType: Storable.Type = Storable.self,
        _ event: CodableStore<Storable>.Event
    ) {
        // Initialize the Emit closure
        let emit: () -> Void = { [weak self] in
            // Verify self is available
            guard let self = self else {
                // Otherwise return out of function
                return
            }
            // Invoke observations and filter out any deallocated observer
            self.observations = self.observations.filter { $0(event) }
        }
        // Check if the current Thread is the main thread
        if Thread.isMainThread {
            // Execture the emit closure
            emit()
        } else {
            // Otherwise dispatch on main queue and execute emit
            DispatchQueue.main.async(execute: emit)
        }
    }
    
}
