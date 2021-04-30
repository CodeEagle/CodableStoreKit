//
//  CodableStoreEngine.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - CodableStoreEngine

/// The CodableStoreEngine
public protocol CodableStoreEngine {
    
    /// Save CodableStorable
    ///
    /// - Parameter storable: The CodableStorable to save
    /// - Returns: The saved CodableStorable
    /// - Throws: If saving fails
    @discardableResult
    func save<Storable: CodableStorable>(_ storable: Storable,
                                         in container: CodableStoreContainer) throws -> Storable
    
    /// Delete CodableStorable via Identifier
    ///
    /// - Parameter identifier: The CodableStorable Identifier
    /// - Returns: The deleted CodableStorable
    /// - Throws: If deleting fails
    @discardableResult
    func delete<Storable: CodableStorable>(_ identifier: Storable.Identifier,
                                           in container: CodableStoreContainer) throws -> Storable
    
    /// Delete all CodableStorables in Collection
    ///
    /// - Returns: The deleted CodableStorables
    @discardableResult
    func deleteCollection<Storable: CodableStorable>(in container: CodableStoreContainer) throws -> [Storable]
    
    /// Retrieve CodableStorable via Identifier
    ///
    /// - Parameter identifier: The Ientifier
    /// - Returns: The corresponding CodableStorable
    /// - Throws: If retrieving fails
    func get<Storable: CodableStorable>(identifier: Storable.Identifier,
                                        in container: CodableStoreContainer) throws -> Storable
    
    /// Retrieve all CodableStorables in Collection
    ///
    /// - Returns: The CodableStorables in the Collection
    /// - Throws: If retrieving fails
    func getCollection<Storable: CodableStorable>(in container: CodableStoreContainer) throws -> [Storable]
    
}
