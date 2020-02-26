//
//  CodableStored.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 26.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStored

/// The CodableStored PropertyWrapper
@propertyWrapper
public final class CodableStored<Storable: CodableStorable> where Storable.Identifier: Equatable {
    
    // MARK: Properties
    
    /// The CodableStore
    public let codableStore: CodableStore<Storable>
    
    /// The optional Storable
    public var storable: Storable?
    
    // MARK: Initializer
    
    /// Designated Initializer
    public init() {
        self.codableStore = .init()
        self.makeObservation()
    }
    
    /// Designated Initializer with an optional initial CodableStorable
    /// - Parameters:
    ///   - wrappedValue: The optional initial CodableStorable. Default value
    public init(
        wrappedValue: Storable? = nil
    ) {
        self.codableStore = .init()
        self.storable = wrappedValue
        if let storable = storable {
            self.wrappedValue = storable
        }
        self.makeObservation()
    }
    
    /// Designated Initializer with an optional initial CodableStorable and CodableStore
    /// - Parameters:
    ///   - wrappedValue: The optional initial CodableStorable. Default value
    ///   - codableStore: The CodableStore. Default value `.init`
    public init(
        wrappedValue: Storable? = nil,
        codableStore: CodableStore<Storable> = .init()
    ) {
        self.codableStore = codableStore
        self.storable = wrappedValue
        if let storable = storable {
            self.wrappedValue = storable
        }
        self.makeObservation()
    }
    
    /// Designated Initializer with optionl CodableStorable Identifier
    /// - Parameters:
    ///   - identifier: The optional CodableStorable Identifier that should be retrieved initially. Default value `nil`
    public init(
        identifier: Storable.Identifier? = nil
    ) {
        self.codableStore = .init()
        self.storable = try? identifier.flatMap(self.codableStore.get)?.get()
        self.makeObservation()
    }
    
    /// Designated Initializer with optionl CodableStorable Identifier and CodableStore
    /// - Parameters:
    ///   - identifier: The optional CodableStorable Identifier that should be retrieved initially. Default value `nil`
    ///   - codableStore: The CodableStore. Default value `.init()`
    public init(
        identifier: Storable.Identifier? = nil,
        codableStore: CodableStore<Storable> = .init()
    ) {
        self.codableStore = codableStore
        self.storable = try? identifier.flatMap(self.codableStore.get)?.get()
        self.makeObservation()
    }
    
    // MARK: Wrapped Value
    
    /// The wrapped CodableStorable Value
    public var wrappedValue: Storable? {
        set {
            // Store current Storable representation
            let currentStorable = self.storable
            // Update Storable
            self.storable = newValue
            // Async on CodableStore
            self.codableStore.async { codableStore in
                // Check if a new CodableStorable is available
                if let storable = newValue {
                    // Save the CodableStorable
                    codableStore.save(storable)
                } else if let storable = currentStorable {
                    // If the new CodableStorable is nil
                    // and the previous CodableStorable is available
                    // Remove it from CodableStore
                    codableStore.remove(storable)
                }
            }
        }
        get {
            // Return CodableStorable
            self.storable
        }
    }
    
}

// MARK: - Make Observation

extension CodableStored {
    
    /// Make Observation
    func makeObservation() {
        // Observe CodableStore
        self.codableStore.observe(on: self) { notification in
            // Switch on Event
            switch notification.event {
            case .saved(let storable):
                // Verify the identifier are equal
                guard storable.identifier == self.storable?.identifier else {
                    // Otherwise return out of function
                    return
                }
                // Set Storable
                self.storable = storable
            case .removed(let identifier):
                // Verify the identifier are equal
                guard identifier == self.storable?.identifier else {
                    // Otherwise return out of function
                    return
                }
                // Clear Storable
                self.storable = nil
            case .removedAll:
                // Clear Storable
                self.storable = nil
            }
        }
    }
    
}
