//
//  CodableStore+Update.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 22.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Update

public extension CodableStore {
    
    /// Update a CodableStorable by its identifier
    /// - Parameters:
    ///   - identifier: The CodableStorable identifier
    ///   - modification: The modification closure
    @discardableResult
    func update(
        _ identifier: Storable.Identifier,
        _ modification: (inout Storable) -> Void
    ) -> Result<Storable, Error> {
        // Switch on get by identifier
        switch self.get(identifier) {
        case .success(var storable):
            // Invoke the modification closure with mutable Storable
            modification(&storable)
            // Return Result of saving the modified Storable
            return self.save(storable)
        case .failure(let error):
            // Return failure
            return .failure(error)
        }
    }
    
}
