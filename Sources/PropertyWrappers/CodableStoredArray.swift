//
//  CodableStoredArray.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 26.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStoredArray

/// The CodableStoredArray PropertyWrapper
@propertyWrapper
public final class CodableStoredArray<Storable: CodableStorable> where Storable.Identifier: Equatable {

    // MARK: Properties
    
    /// The CodableStore
    public let codableStore: CodableStore<Storable>
    
    /// The Storables
    public var storables: [Storable] = .init()
    
    // MARK: Initializer
    
    /// Designated Initializer
    public init() {
        self.codableStore = .init()
        self.storables = (try? self.codableStore.getAll().get()) ?? .init()
    }
    
    /// Designated Initializer with CodableStore
    /// - Parameter codableStore: The CodableStore. Default value `.init()`
    public init(wrappedValue: [Storable]) {
        self.codableStore = .init()
        self.storables = (try? self.codableStore.getAll().get()) ?? .init()
        self.codableStore.save(wrappedValue)
    }
    
    /// Designated Initializer with CodableStore
    /// - Parameter codableStore: The CodableStore. Default value `.init()`
    public init(wrappedValue: [Storable], codableStore: CodableStore<Storable> = .init()) {
        self.codableStore = codableStore
        self.storables = (try? self.codableStore.getAll().get()) ?? .init()
    }
    
    // MARK: Wrapped Value
    
    /// The wrapped CodableStorable Value
    public var wrappedValue: [Storable] {
        set {
            // Store current/old Storables value
            let oldValue = self.storables
            // Update Storable
            self.storables = newValue
            // Async on CodableStore
            self.codableStore.async { codableStore in
                let oldValueIdentifiers = oldValue.map { $0.identifier }
                let newValueIdentifiers = newValue.map { $0.identifier }
                let newStorables = newValue.filter { !oldValueIdentifiers.contains($0.identifier) }
                let removedStorables = oldValue.filter { !newValueIdentifiers.contains($0.identifier) }
                codableStore.save(newStorables)
                codableStore.remove(removedStorables)
            }
        }
        get {
            // Return CodableStorables
            self.storables
        }
    }
    
}
