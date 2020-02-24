//
//  CodableStore+Get.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 07.12.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Get

public extension CodableStore {
    
    /// Retrieve CodableStorable by identifier
    /// - Parameter identifier: The identifier to retrieve CodableStorable
    func get(_ identifier: Storable.Identifier) -> Result<Storable, Error> {
        // Declare URL
        let url: URL
        // Switch on Result of URL for Identifier
        switch self.url(for: identifier) {
        case .success(let storableURL):
            // Initialize URL
            url = storableURL
        case .failure(let error):
            // Return failure
            return .failure(error)
        }
        // Verify Data for URL is available
        guard let data = self.fileManager.contents(atPath: url.path) else {
            // Otherwise return failure
            return .failure(.fileDataUnavailable(identifier))
        }
        // Declare Storable
        let storable: Storable
        do {
            // Try to decode Storable from Data
            storable = try self.decoder.decode(Storable.self, from: data)
        } catch {
            // Return failure
            return .failure(.decodingFailed(error))
        }
        // Return success
        return .success(storable)
    }
    
    /// Retrieve CodableStorable
    /// - Parameter storable: The CodableStorable that should be retrieved
    func get(_ storable: Storable) -> Result<Storable, Error> {
        // Retrieve Storable by identifier
        self.get(storable.identifier)
    }
    
    /// Retrieve first CodableStorable that satisfy the given predicate
    /// - Parameter predicate: The predicate
    func first(where predicate: (Storable) -> Bool) -> Result<Storable, Error> {
        // Retrieve all with predicate
        self.getAll(where: predicate)
            // FlatMap Result
            .flatMap { storables in
                // Verify first Storable is available
                guard let storable = storables.first else {
                    // Otherwise return failure
                    return .failure(.notFound())
                }
                // Return success
                return .success(storable)
            }
    }
    
}

// MARK: - Get All

public extension CodableStore {
    
    /// Retrieve all CodableStorables
    func getAll() -> Result<[Storable], Error> {
        // Declare URL
        let url: URL
        // Switch on Result of Collection URL
        switch self.collectionURL() {
        case .success(let collectionURL):
            // Initialize URL
            url = collectionURL
        case .failure(let error):
            // Return failure
            return .failure(error)
        }
        // Declare paths String Array
        let paths: [String]
        do {
            // Try to retrieve contents of directory at URL
            paths = try self.fileManager.contentsOfDirectory(atPath: url.path)
        } catch {
            // Return failure
            return .failure(.contentsOfDirectoryUnavailable(url, error))
        }
        // Compact Map Paths to Storable
        let storables: [Storable] = paths.compactMap { path in
            // Initialize URL by appending path component
            let url = url.appendingPathComponent(path)
            // Verify Data for URL is available
            guard let data = self.fileManager.contents(atPath: url.path) else {
                // Otherwise return nil
                return nil
            }
            // Try to decode Storable from Data
            return try? self.decoder.decode(Storable.self, from: data)
        }
        // Return success
        return .success(storables)
    }
    
    /// Retrieve all CodableStorable that satisfy the given predicate
    /// - Parameter predicate: The predicate
    func getAll(where predicate: (Storable) -> Bool) -> Result<[Storable], Error> {
        // Retrieve all and apply filter
        self.getAll().map { $0.filter(predicate) }
    }
    
}

// MARK: - Exists

public extension CodableStore {
    
    /// Retrieve Bool value if a CodableStorable exists for a given identifier
    /// - Parameter identifier: The identifier to check for existence
    func exists(_ identifier: Storable.Identifier) -> Bool {
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
    func exists(_ storable: Storable) -> Bool {
        // Check for existence by identifier
        self.exists(storable.identifier)
    }
    
}
