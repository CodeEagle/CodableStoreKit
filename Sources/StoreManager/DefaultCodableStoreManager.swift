//
//  DefaultCodableStoreManager.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 24.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - DefaultCodableStoreManager

/// The DefaultCodableStoreManager
public final class DefaultCodableStoreManager {
    
    // MARK: Properties
    
    /// The Shared Instance
    public static let sharedInstance = DefaultCodableStoreManager()
    
    /// The Observers
    var observers: Locked<[String: Any]> = .init(.init())
    
    // MARK: Initializer
    
    /// Designated Initializer
    private init() {}
    
}

// MARK: - Observation

extension DefaultCodableStoreManager {
    
    /// The Observation
    struct Observation<Storable: CodableStorable> {
        
        /// The CodableStoreObserverIntent
        let intent: CodableStoreObserverIntent<Storable>
        
        /// The CodableStoreObserver
        let observer: CodableStoreObserver<Storable>
        
    }
    
}

// MARK: - EngineProvidableCodableStoreManager

extension DefaultCodableStoreManager: EngineProvidableCodableStoreManager {
    
    /// Provide Engine for Codable Type in CodableStoreContainer
    ///
    /// - Parameters:
    ///   - codable: The Codable Type
    ///   - container: The CodableStoreContainer
    /// - Returns: A CodableStoreEngine
    public func provideEngine(for codable: Codable.Type,
                              in container: CodableStoreContainer) -> CodableStoreEngine {
        return FileManagerCodableStoreEngine()
    }
    
}

// MARK: - ObservableCodableStoreManager

extension DefaultCodableStoreManager: ObservableCodableStoreManager {
    
    /// Observe with CodableStoreObserverIntent
    ///
    /// - Parameters:
    ///   - intent: The CodableStoreObserverIntent
    ///   - observer: The CodableStoreObserver
    /// - Returns: A CodableStoreSubscription
    @discardableResult
    public func observe<Storable: CodableStorable>(with intent: CodableStoreObserverIntent<Storable>,
                                                   _ observer: @escaping CodableStoreObserver<Storable>) -> CodableStoreSubscription {
        // Initialize a Key
        let key = UUID().uuidString
        // Store Observer for Key
        self.observers.value[key] = Observation(intent: intent, observer: observer)
        // Return CodableStoreSubscription
        return .init {
            // Remove Observer for Key
            self.observers.value.removeValue(forKey: key)
        }
    }
    
}

// MARK: - EmittableCodableStoreManager

extension DefaultCodableStoreManager: EmittableCodableStoreManager {
    
    /// Emit CodableStoreObservedChange
    ///
    /// - Parameter observedChange: The CodableStoreObservedChange
    public func emit<Storable: CodableStorable>(_ observedChange: CodableStoreObservedChange<Storable>) {
        // Compact map Observers Values to Observations
        let observations = self.observers.value.values.compactMap { $0 as? Observation<Storable> }
        // Initialize Storable
        let storable = observedChange.storable
        // For each Observation
        for observation in observations {
            // Switch on Observation Intent
            switch observation.intent {
            case .identifier(let identifier):
                // Verify Identifier matches
                guard storable.identifier.stringRepresentation == identifier.stringRepresentation else {
                    // Continue with next Observation
                    continue
                }
            case .predicate(let predicate):
                // Verify predicate matches
                guard predicate(storable) else {
                    // Continue with next Observation
                    continue
                }
            case .all:
                // Break out of switch as no verification is needed
                break
            }
            // Dispatch on Main Queue
            DispatchQueue.main.async {
                // Invoke Observer with ObservedChange Event
                observation.observer(observedChange)
            }
        }
    }
    
}
