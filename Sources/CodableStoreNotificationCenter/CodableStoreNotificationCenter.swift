//
//  CodableStoreNotificationCenter.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 21.11.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStoreNotificationCenter

/// The CodableStoreNotificationCenter
open class CodableStoreNotificationCenter {
    
    // MARK: Static Properties
    
    /// The default shared instance of CodableStoreNotificationCenter
    public static let `default` = CodableStoreNotificationCenter()
    
    // MARK: Typealias
    
    /// The Observation typealias
    public typealias Observation = (Any) -> Bool
    
    // MARK: Properties
    
    /// The Observations
    open var observations: [Observation] = .init()
    
    // MARK: Initializer
    
    /// Designated Initializer
    public init() {}
    
    // MARK: Observe
    
    /// Observe all Notifications on any CodableStore in any CodableStoreContainer
    /// - Parameters:
    ///   - object: The Object to observe on
    ///   - observer: The Observer
    open func observeAll<Object: AnyObject>(
        on object: Object,
        observer: @escaping () -> Void
    ) {
        // Initialize Observation
        let observation: Observation = { [weak object] _ in
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
        // Dispatch on main if needed
        DispatchQueue.dispatchOnMainIfNeed { [weak self] in
            // Append Observation
            self?.observations.append(observation)
        }
    }
    
    /// Observe CodableStore Notifications
    /// - Parameters:
    ///   - object: The Object to observe on
    ///   - storableType: The Storable Type. Default value `Storable.self`
    ///   - container: The optional CodableStoreContainer where the Notification should occurs. Default value `nil`
    ///   - observer: The Observer
    open func observe<Object: AnyObject, Storable: CodableStorable>(
        on object: Object,
        storableType: Storable.Type = Storable.self,
        in container: CodableStoreContainer? = nil,
        _ observer: @escaping (CodableStore<Storable>.Notification) -> Void
    ) {
        // Initialize Observation
        let observation: Observation = { [weak object] notification in
            // Verify Object is still available
            guard object != nil else {
                // Object isn't available return false
                // To indicate that the observation can be removed
                return false
            }
            // Verify Notification matches the Storable type
            guard let notification = notification as? CodableStore<Storable>.Notification else {
                // Otherwise return true as the Storable type
                // doesn't match the current one
                return true
            }
            // Check if a Container is available and the Notification Container is not equal to it
            if let container = container, notification.container != container {
                // Return true as the Containers doesn't match
                return true
            }
            // Invoke Observer with Notification
            observer(notification)
            // Return true
            return true
        }
        // Dispatch on main if needed
        DispatchQueue.dispatchOnMainIfNeed { [weak self] in
            // Append Observation
            self?.observations.append(observation)
        }
    }
    
    // MARK: Emit
    
    /// Emit CodableStore  Notification
    /// - Parameters:
    ///   - storableType: The Storable Type. Default value `Storable.self`
    ///   - notification: The CodableStore Notification that should be emitted
    open func emit<Storable: CodableStorable>(
        storableType: Storable.Type = Storable.self,
        _ notification: CodableStore<Storable>.Notification
    ) {
        // Dispatch on Main if needed
        DispatchQueue.dispatchOnMainIfNeed { [weak self] in
            // Verify self is available
            guard let self = self else {
                // Otherwise return out of function
                return
            }
            // Invoke observations and filter out any deallocated observer
            self.observations = self.observations.filter { $0(notification) }
        }
    }
    
}

// MARK: - DispatchQueue+dispatchOnMainIfNeed

private extension DispatchQueue {
    
    /// Dispatch on Main Queue if needed
    /// - Parameter work: The work that should be executed
    static func dispatchOnMainIfNeed(execute work: @escaping () -> Void) {
        // Verify is not main thread
        guard !Thread.isMainThread else {
            // Otherwise execute the work
            return work()
        }
        // Dispatch on main queue and execute work
        self.main.async(execute: work)
    }
    
}
