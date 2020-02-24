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
    func url(for storable: Storable) -> Result<URL, Error> {
        self.url(for: storable.identifier)
    }
    
    /// Retrieve URL for CodableStorable by its identifier
    /// - Parameter identifier: The CodableStorable Identifier
    func url(for identifier: Storable.Identifier) -> Result<URL, Error> {
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
        return self.collectionURL()
            .map { url in
                // Append sanitized Identifier String representation
                url.appendingPathComponent(identifierStringRepresentation.sanitized())
            }
    }
    
    /// The CodableStorable Collection URL
    func collectionURL() -> Result<URL, Error> {
        // Retrieve Container URL
        self.containerURL()
            .map { url in
                // Append sanitized CodableStore CollectionName
                url.appendingPathComponent(Storable.codableStoreCollectionName.sanitized())
            }.flatMap { url in
                // Check if Directory doesn't exists
                if !self.fileManager.fileExists(atPath: url.path) {
                    do {
                        // Try to create Directory
                        try self.fileManager.createDirectory(
                            atPath: url.path,
                            withIntermediateDirectories: true,
                            attributes: nil
                        )
                    } catch {
                        // Return failure
                        return .failure(.constructingURLFailed(error))
                    }
                }
                // Return success
                return .success(url)
            }
    }
    
    /// The CodableStore Container URL
    func containerURL() -> Result<URL, Error> {
        // Declare searchPathDirectory
        let searchPathDirectory: FileManager.SearchPathDirectory
        #if os(tvOS)
        // tvOS only supports the cache directory
        searchPathDirectory = .cachesDirectory
        #else
        // On other Platforms use the document directory
        searchPathDirectory = .documentDirectory
        #endif
        do {
            // Try to initialize URL for search path directory
            let url = try self.fileManager.url(
                for: searchPathDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            // Return Container URL
            return .success(url.appendingPathComponent(self.container.name.sanitized()))
        } catch {
            // Return failure
            return .failure(.constructingURLFailed(error))
        }
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
