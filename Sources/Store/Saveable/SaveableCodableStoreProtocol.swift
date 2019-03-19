//
//  SaveableCodableStoreProtocol.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - SaveableCodableStoreProtocol

/// The SaveableCodableStoreProtocol
public protocol SaveableCodableStoreProtocol {
    
    /// The Storable associatedtype which is constrainted to `CodableStorable`
    associatedtype Storable: CodableStorable
    
    /// Save CodableStorable
    ///
    /// - Parameter storable: The CodableStorable to save
    /// - Returns: The saved CodableStorable
    /// - Throws: If saving fails
    @discardableResult
    func save(_ storable: Storable) throws -> Storable
    
}

// MARK: - SaveableCodableStoreProtocol Convenience Functions

public extension SaveableCodableStoreProtocol {
    
    /// Save CodableStorable Array
    ///
    /// - Parameter storables: The CodableStorable Objects to save
    /// - Returns: The saved CodableStorable Array
    /// - Throws: If saving fails
    func save(_ storables: [Storable]) throws -> [Storable] {
        return try storables.map(self.save)
    }
    
}
