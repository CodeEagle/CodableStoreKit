//
//  ObserverStorage.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 05.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - ObserverStorage

/// The ObserverStorage
class ObserverStorage {
    
    // MARK: Properties
    
    /// The internal sharedInstance of ObserverStorage
    static let sharedInstance = ObserverStorage()
    
    /// The Thread Safe Observers Array
    /// As we are dealing with heterogeneous generic Elements
    /// The observers Array is declared as type Any
    private var observers: Locked<[Any]>
    
    // MARK: Initializer
    
    /// Designated Private Initializer
    private init() {
        /// Init Observers
        self.observers = .init(.init())
    }
    
    // MARK: API
    
    /// Retrieve Observer for Object Type
    ///
    /// - Parameter objectType: The Object Type
    /// - Returns: AnyObservableCodableStore Object
    func getObserver<Object: BaseCodableStoreable>(objectType: Object.Type) -> AnyObserverableCodableStore<Object> {
        // Verify a Observer is available
        guard let observer = self.getObserverObject(objectType: Object.self) else {
            // Initialize a new Observer
            let newObserver = AnyObserverableCodableStore<Object>()
            // Append it to the Observers array
            self.observers.value.append(newObserver)
            // Return new Observer
            return newObserver
        }
        // Return existing Observer
        return observer
    }
    
    /// Clear Observer Usage
    /// Removes Observer if is empty
    ///
    /// - Parameter objectType: The ObjectType
    func clearObserveUsage<Object: BaseCodableStoreable>(objectType: Object.Type) {
        // Unwrap Observer and verify it's empty
        guard let observer = self.getObserverObject(objectType: Object.self), observer.isEmpty else {
            // Return out of function
            return
        }
        // Remove Observer
        self.observers.mutate { (observers) in
            observers = observers.filter { !($0 is AnyObserverableCodableStore<Object>) }
        }
    }
    
    // swiftlint:disable line_length
    /// Retrieve Observer Object for Object Type
    ///
    /// - Parameter objectType: The Object Type
    /// - Returns: The AnyObserverableCodableStore
    private func getObserverObject<Object: BaseCodableStoreable>(objectType: Object.Type) -> AnyObserverableCodableStore<Object>? {
        return self.observers.value.compactMap({ $0 as? AnyObserverableCodableStore<Object> }).first
    }
    // swiftlint:enable line_length
    
}
