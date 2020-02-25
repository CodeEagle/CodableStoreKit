//
//  CodableStore+Contains.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 25.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Contains

public extension CodableStore {
    
    /// Retrieve Bool value if a CodableStorable exists for a given identifier
    /// - Parameter identifier: The identifier to check for existence
    func contains(_ identifier: Storable.Identifier) -> Bool {
        // Verfy Storable URL is available
        guard let url = try? self.url(for: identifier).get() else {
            // Otherwise return false
            return false
        }
        // Return if Storable exists at URL
        return self.fileManager.fileExists(atPath: url.path)
    }
    
    /// Retrieve Bool value if the CodableStorable exists
    /// - Parameter storable: The CodableStorable to check for existence
    func contains(_ storable: Storable) -> Bool {
        // Check for existence by identifier
        self.contains(storable.identifier)
    }
    
}
