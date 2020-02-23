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
        do {
            // Try to make Storable URL with identifier
            url = try self.makeStorableURL(identifier: identifier)
        } catch {
            // Return failure
            return .failure(.constructingURLFailed(error))
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
        do {
            // Try to make collection url
            url = try self.makeCollectionURL()
        } catch {
            // Return failure
            return .failure(.constructingURLFailed(error))
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
        // Verfy Storable URL with identifier is available
        guard let url = try? self.makeStorableURL(identifier: identifier) else {
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

// MARK: - Creation/Modification Date

public extension CodableStore {
    
    /// Retrieve creation Date for CodableStorable Identifier
    /// - Parameter identifier: The Identifier to retrieve creation Date
    func getCreationDate(_ identifier: Storable.Identifier) -> Date? {
        self.getAttribute(for: identifier, key: .creationDate)
    }
    
    /// Retrieve creation Date for CodableStorable
    /// - Parameter storable: The CodableStorable to retrieve creation Date
    func getCreationDate(_ storable: Storable) -> Date? {
        self.getCreationDate(storable.identifier)
    }
    
    /// Retrieve modification Date for CodableStorable Identifier
    /// - Parameter identifier: The Identifier to retrieve modification Date
    func getModificationDate(_ identifier: Storable.Identifier) -> Date? {
        self.getAttribute(for: identifier, key: .modificationDate)
    }
    
    /// Retrieve modification Date for CodableStorable
    /// - Parameter storable: The CodableStorable to retrieve modification Date
    func getModificationDate(_ storable: Storable) -> Date? {
        self.getModificationDate(storable.identifier)
    }
    
}

// MARK: - (Internal) Get File Attribute

extension CodableStore {
    
    /// Retrieve FileAttributeKey Value for a given CodableStorable Identifier
    /// - Parameters:
    ///   - identifier: The CodableStorable Identifier to retrieve FileAttributeKey Value
    ///   - key: The FileAttributeKey
    func getAttribute<T>(for identifier: Storable.Identifier, key: FileAttributeKey) -> T? {
        // Verify CodableStorable URL is available
        guard let url = try? self.makeStorableURL(identifier: identifier) else {
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
