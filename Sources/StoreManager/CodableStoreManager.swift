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
    static var observers: Locked<[AnyHashable: (identifier: AnyHashable, observer: Any)]> = .init(.init())
    
    static func emit<Storable: CodableStorable>(type: Storable.Type,
                                                _ observedChange: CodableStoreObservedChange<Storable>) {
        Array(self.observers.value.values)
            .filter { $0.identifier == AnyHashable(observedChange.storable.identifier.stringRepresentation) }
            .compactMap { $0.observer as? (CodableStoreObservedChange<Storable>) -> Void }
            .forEach { $0(observedChange) }
    }
    
}
