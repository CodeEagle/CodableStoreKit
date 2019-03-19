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
public final class CodableStoreManager {
    
    /// The EngineProvider Typealias
    public typealias EngineProvider = (Codable.Type, CodableStoreContainer) -> CodableStoreEngine
    
    /// The Engine Provider
    public static var engineProvider: EngineProvider = { _, _  in
        FileManagerCodableStoreEngine()
    }
    
    /// The Observers
    static var observers: Locked<[AnyHashable: Any]> = .init(.init())
    
}

// MARK: - Observation

extension CodableStoreManager {
    
    /// The Observer Intent
    enum ObserverIntent<Storable: CodableStorable> {
        /// Matches Identifier
        case identifier(Storable.Identifier)
        /// Matches Predicate
        case predicate((Storable) -> Bool)
        /// Matches all
        case all
    }
    
    /// The Observation
    struct Observation<Storable: CodableStorable> {
        
        /// The Intent
        let intent: ObserverIntent<Storable>
        
        /// The Observer
        let observer: (CodableStoreObservedChange<Storable>) -> Void
        
    }
    
}

// MARK: - Add Observer

extension CodableStoreManager {
    

    
    /// Add Observer for CodableStorable Identifier
    ///
    /// - Parameters:
    ///   - identifier: The CodableStorable Identifier
    ///   - observer: The Observer
    /// - Returns: A CodableStoreSubscription
    static func addObserver<Storable: CodableStorable>(_ intent: ObserverIntent<Storable>,
                                                       _ observer: @escaping (CodableStoreObservedChange<Storable>) -> Void) -> CodableStoreSubscription {
        // Initialize a Key
        let key = UUID().uuidString
        // Store Observer for Key
        self.observers.value[key] = Observation(intent: intent, observer: observer)
        // Return CodableStoreSubscription
        return CodableStoreSubscription {
            // Remove Observer for Key
            self.observers.value.removeValue(forKey: key)
        }
    }
    
}

// MARK: - Emit CodableStoreObservedChange

extension CodableStoreManager {
    
    /// Emit CodableStoreObservedChange
    ///
    /// - Parameters:
    ///   - observedChange: The CodableStoreObservedChange
    static func emit<Storable: CodableStorable>(_ observedChange: CodableStoreObservedChange<Storable>) {
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
            // Invoke Observer with ObservedChange Event
            observation.observer(observedChange)
        }
    }
    
}
