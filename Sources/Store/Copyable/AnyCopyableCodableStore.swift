//
//  AnyCopyableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - AnyCopyableCodableStore (Type-Erasure)

/// The AnyCopyableCodableStore
public struct AnyCopyableCodableStore<Object: BaseCodableStoreable> {
    
    // MARK: Properties
    
    /// The copy to CodableStore closure
    private let copyToCodableStoreClosure: (CodableStore<Object>, ((Object) -> Bool)?) throws -> [CodableStore<Object>.Result]
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter copyableCodableStore: The CopyableCodableStore
    init<C: CopyableCodableStore>(_ copyableCodableStore: C) where C.Object == Object {
        self.copyToCodableStoreClosure = {
            try copyableCodableStore.copy(toStore: $0, where: $1)
        }
    }
    
}

// MARK: - CopyableCodableStore

extension AnyCopyableCodableStore: CopyableCodableStore {
    
    /// Copy the current Collection data to another CodableStore
    ///
    /// - Parameters:
    ///   - codableStore: The target CodableStore to insert data
    ///   - filter: The optional Filter
    /// - Returns: CodableStore Result Array
    /// - Throws: If copying fails
    @discardableResult
    public func copy(toStore codableStore: CodableStore<Object>,
                     where filter: ((Object) -> Bool)?) throws -> [CodableStore<Object>.Result] {
        return try self.copyToCodableStoreClosure(codableStore, filter)
    }

}
