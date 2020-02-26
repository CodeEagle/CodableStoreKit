//
//  CodableStore+Async.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 25.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Async

public extension CodableStore {
    
    /// Schedules a block asynchronously for execution with a `CodableStore`
    /// - Parameters:
    ///   - queue: The dispatch group. Default value `.global()`
    ///   - group: The dispatch group to associate with the work item. Default value `nil`
    ///   - qos: The quality-of-service class to use when executing the block. Default value `.unspecified`
    ///   - flags: Additional attributes to apply when executing the block. Default value `.init()`
    ///   - execute: The block containing the work with a `CodableStore` to perform.
    func async(
        queue: DispatchQueue = .global(),
        group: DispatchGroup? = nil,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = .init(),
        execute: @escaping (CodableStore<Storable>) -> Void
    ) {
        // Get a CodableStore with local reference
        let codableStore = self
        // Dispatch on queue
        queue.async(
            group: group,
            qos: qos,
            flags: flags
        ) {
            // Execute the block with the CodableStore
            execute(codableStore)
        }
    }
    
}

// MARK: - AsyncAfter

public extension CodableStore {
    
    /// Schedules a block for execution with a  `CodableStore`
    /// - Parameters:
    ///   - queue: The dispatch group. Default value `.global()`
    ///   - deadline: The time at which to schedule the block for execution.
    ///   - qos: The quality-of-service class to use when executing the block. Default value `.unspecified`
    ///   - flags: Additional attributes to apply when executing the block. Default value `.init()`
    ///   - execute: The block containing the work with a `CodableStore` to perform.
    func asyncAfer(
        queue: DispatchQueue = .global(),
        deadline: DispatchTime,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = .init(),
        execute: @escaping (CodableStore<Storable>) -> Void
    ) {
        // Get a CodableStore with local reference
        let codableStore = self
        // Dispatch after deadline on queue
        queue.asyncAfter(
            deadline: deadline,
            qos: qos,
            flags: flags
        ) {
            // Execute the block with the CodableStore
            execute(codableStore)
        }
    }
    
}
