//
//  CodableStore+URLs.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 22.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Make URL

public extension CodableStore {
    
    /// Retrieve URL for CodableStorable
    /// - Parameter storable: The CodableStorable
    func url(for storable: Storable) throws -> URL {
        try self.url(for: storable.identifier)
    }
    
    /// Retrieve URL for CodableStorable by its identifier
    /// - Parameter identifier: The CodableStorable Identifier
    func url(for identifier: Storable.Identifier) throws -> URL {
        // Declare the Identifier String representation
        let identifierStringRepresentation: String
        // Check if the Identifier is a String
        if let identifier = identifier as? String {
            // Initialize String representation
            identifierStringRepresentation = identifier
        } else {
            // Otherwise convert Identifier via String Interpolation to a String
            identifierStringRepresentation = "\(identifier)"
        }
        // Make collection url and append sanitized identifier
        return try self.collectionURL()
            .appendingPathComponent(identifierStringRepresentation.sanitized())
    }
    
    /// The CodableStorable Collection URL
    func collectionURL() throws -> URL {
        // Initialize URL via appending collection name to sanitized container url
        let url = try self.containerURL()
            .appendingPathComponent(Storable.codableStoreCollectionName.sanitized())
        // Check if Directory doesn't exists
        if !self.fileManager.fileExists(atPath: url.path) {
            // Try to create Directory
            try self.fileManager.createDirectory(
                atPath: url.path,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        // Return url
        return url
    }
    
    /// The CodableStore Container URL
    func containerURL() throws -> URL {
        // Declare searchPathDirectory
        let searchPathDirectory: FileManager.SearchPathDirectory
        #if os(tvOS)
        // tvOS only supports the cache directory
        searchPathDirectory = .cachesDirectory
        #else
        // On other Platforms use the document directory
        searchPathDirectory = .documentDirectory
        #endif
        // Return SearchPathDirectory URL
        let url = try self.fileManager.url(
            for: searchPathDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        // Return Container URL
        return url.appendingPathComponent(self.container.name.sanitized())
    }
    
}

// MARK: - String+sanitized

private extension String {
    
    /// Sanitize String
    ///
    /// - Parameter replacingCharacter: The replacing character. Default value `_`
    /// - Returns: The sanitized raw value
    func sanitized(replacingCharacter: String = "_") -> String {
        return self.replacingOccurrences(
            of: "[^.A-Za-z0-9]+",
            with: replacingCharacter,
            options: [.regularExpression]
        )
    }
    
}
