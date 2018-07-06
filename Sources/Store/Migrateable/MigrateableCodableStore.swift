//
//  MigrateableCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - MigrateableCodableStore

/// The MigrateableCodableStore Protocol
public protocol MigrateableCodableStore {
    
    /// The associatedtype BaseCodableStoreable Object
    associatedtype Object: BaseCodableStoreable
    
    /// Migrate current Collection data to another Container in a specific Engine
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer
    ///   - engine: The Engine
    /// - Returns: Dictionary of saved objects with id and optional Error
    /// - Throws: If migration fails
    @discardableResult
    func migrate(toContainer container: CodableStoreContainer,
                 inEngine engine: CodableStore<Object>.Engine) throws -> [Object.ID: Error?]
    
}
