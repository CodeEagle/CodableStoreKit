//
//  CodableStore+Attributes.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 24.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Creation Date

public extension CodableStore {
    
    /// Retrieve creation Date for CodableStorable Identifier
    /// - Parameter identifier: The Identifier to retrieve creation Date
    func creationDate(_ identifier: Storable.Identifier) -> Date? {
        self.attribute(for: identifier, key: .creationDate)
    }
    
    /// Retrieve creation Date for CodableStorable
    /// - Parameter storable: The CodableStorable to retrieve creation Date
    func creationDate(_ storable: Storable) -> Date? {
        self.creationDate(storable.identifier)
    }
    
}

// MARK: - Modification Date

public extension CodableStore {
    
    /// Retrieve modification Date for CodableStorable Identifier
    /// - Parameter identifier: The Identifier to retrieve modification Date
    func modificationDate(_ identifier: Storable.Identifier) -> Date? {
        self.attribute(for: identifier, key: .modificationDate)
    }
    
    /// Retrieve modification Date for CodableStorable
    /// - Parameter storable: The CodableStorable to retrieve modification Date
    func modificationDate(_ storable: Storable) -> Date? {
        self.modificationDate(storable.identifier)
    }
    
}

// MARK: - (Internal) Get File Attribute

extension CodableStore {
    
    /// Retrieve FileAttributeKey Value for a given CodableStorable Identifier
    /// - Parameters:
    ///   - identifier: The CodableStorable Identifier to retrieve FileAttributeKey Value
    ///   - key: The FileAttributeKey
    func attribute<T>(for identifier: Storable.Identifier, key: FileAttributeKey) -> T? {
        // Verify URL for CodableStorable Identifier is available
        guard let url = try? self.url(for: identifier) else {
            // Otheriwse return nil
            return nil
        }
        // Verify Attributes at path are available
        guard let attributes = try? self.fileManager.attributesOfItem(atPath: url.path) else {
            // Otherwise return nil
            return nil
        }
        // Return creation Date
        return attributes[key] as? T
    }
    
}
