//
//  CodableStore+URL.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 22.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Make URL

extension CodableStore {
    
    /// Make Storable URL with identifier
    /// - Parameter identifier: The identifier value
    func makeStorableURL(identifier: Storable.Identifier) throws -> URL {
        // Make collection url and append sanitized identifier
        try self.makeCollectionURL().appendingPathComponent(identifier.sanitized())
    }
    
    /// Make Collection URL
    func makeCollectionURL() throws -> URL {
        // Initialize URL via appending collection name to sanitized container url
        let url = try self.makeContainerURL()
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
    
    /// Make Container URL
    func makeContainerURL() throws -> URL {
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

// MARK: - Clear Directories if needed

extension CodableStore {
    
    /// Clear directories if needed
    func clearDirectoriesIfNeeded() {
        // Initialize delete if empty closure
        let deleteIfEmpty: (URL) -> Void = { url in
            // Verfy content of directory is available for url
            guard let paths = try? self.fileManager.contentsOfDirectory(atPath: url.path) else {
                // Otherwise return
                return
            }
            // Verify paths are empty
            guard paths.isEmpty else {
                // Otherwise return
                return
            }
            // Remove item at url
            try? self.fileManager.removeItem(at: url)
        }
        // Delete Collection-Directory if Empty
        (try? self.makeCollectionURL()).flatMap(deleteIfEmpty)
        // Delete Container-Directory if Empty
        (try? self.makeContainerURL()).flatMap(deleteIfEmpty)
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
