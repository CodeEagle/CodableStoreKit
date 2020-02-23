//
//  AsyncCodableStore.swift
//  CodableStoreKit-iOS
//
//  Created by Sven Tiigi on 23.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - AsyncCodableStore

/// The AsyncCodableStore
public struct AsyncCodableStore<Storable: CodableStorable>: Equatable {
    
    // MARK: Properties
    
    /// The DispatchQueue
    public var queue: DispatchQueue
    
    /// The CodableStore
    let codableStore: CodableStore<Storable>
    
    // MARK: Initializer
    
    /// Designated Initializer
    /// - Parameters:
    ///   - queue: The DispatchQueue. Default value `.global()`
    ///   - codableStore: The CodableStore. Default value `.init()`
    public init(
        queue: DispatchQueue = .global(),
        codableStore: CodableStore<Storable> = .init()
    ) {
        self.queue = queue
        self.codableStore = codableStore
    }
    
}

// MARK: - Async

public extension AsyncCodableStore {
    
    /// Schedules a block asynchronously for execution with a `CodableStore`
    /// - Parameters:
    ///   - group: The dispatch group to associate with the work item. Default value `nil`
    ///   - qos: The quality-of-service class to use when executing the block. Default value `.unspecified`
    ///   - flags: Additional attributes to apply when executing the block. Default value `.init()`
    ///   - execute: The block containing the work with a `CodableStore` to perform.
    func async(
        group: DispatchGroup? = nil,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = .init(),
        execute: @escaping (CodableStore<Storable>) -> Void
    ) {
        // Get a CodableStore with local reference
        let codableStore = self.codableStore
        // Dispatch on queue
        self.queue.async(
            group: group,
            qos: qos,
            flags: flags
        ) {
            // Execute the block with the CodableStore
            execute(codableStore)
        }
    }
    
    /// Schedules a block for execution with a  `CodableStore`
    /// - Parameters:
    ///   - deadline: The time at which to schedule the block for execution.
    ///   - qos: The quality-of-service class to use when executing the block. Default value `.unspecified`
    ///   - flags: Additional attributes to apply when executing the block. Default value `.init()`
    ///   - execute: The block containing the work with a `CodableStore` to perform.
    func asyncAfer(
        deadline: DispatchTime,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = .init(),
        execute: @escaping (CodableStore<Storable>) -> Void
    ) {
        // Get a CodableStore with local reference
        let codableStore = self.codableStore
        // Dispatch after deadline on queue
        self.queue.asyncAfter(
            deadline: deadline,
            qos: qos,
            flags: flags
        ) {
            // Execute the block with the CodableStore
            execute(codableStore)
        }
    }
    
}
