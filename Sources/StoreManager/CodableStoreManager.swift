//
//  CodableStoreManager.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - CodableStoreManager

/// The CodableStoreManager
public typealias CodableStoreManager = EngineProvidableCodableStoreManager & ObservableCodableStoreManager & EmittableCodableStoreManager

// MARK: - EngineProvidableCodableStoreManager

/// The EngineProvidableCodableStoreManager
public protocol EngineProvidableCodableStoreManager {
    
    /// Provide Engine for Codable Type in CodableStoreContainer
    ///
    /// - Parameters:
    ///   - codable: The Codable Type
    ///   - container: The CodableStoreContainer
    /// - Returns: A CodableStoreEngine
    func provideEngine(for codable: Codable.Type, in container: CodableStoreContainer) -> CodableStoreEngine
    
}

// MARK: - ObservableCodableStoreManager

/// The ObservableCodableStoreManager
public protocol ObservableCodableStoreManager {
    
    /// Subscribe with CodableStoreObserverIntent
    ///
    /// - Parameters:
    ///   - intent: The CodableStoreObserverIntent
    ///   - observer: The CodableStoreObserver
    /// - Returns: A CodableStoreSubscription
    @discardableResult
    func subscribe<Storable: CodableStorable>(with intent: CodableStoreObserverIntent<Storable>,
                                              _ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription
    
}

// MARK: - EmittableCodableStoreManager

/// The EmittableCodableStoreManager
public protocol EmittableCodableStoreManager {
    
    /// Emit CodableStoreObservedChange
    ///
    /// - Parameter observedChange: The CodableStoreObservedChange
    func emit<Storable: CodableStorable>(_ observedChange: CodableStoreObservedChange<Storable>)
    
}
