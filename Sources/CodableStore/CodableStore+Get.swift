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
    
    /// The SortMode
    enum SortMode {
        /// Ascending order by modification date
        case ascending
        /// Descending order by modification date
        case descending
        /// Custom order by predicate
        case custom((Storable, Storable) -> Bool)
    }
    
    /// Retrieve all CodableStorables
    /// - Parameter sortMode: The SortMode. Default value `.descending`
    func getAll(
        sortMode: SortMode = .descending
    ) -> Result<[Storable], Error> {
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
        // CompactMap Paths to Files
        var files: [(data: Data, modificationDate: Date?)] = paths
            .compactMap { path in
                // Initialize URL by appending path component
                let url = url.appendingPathComponent(path)
                // Verify Data for URL is available
                guard let data = self.fileManager.contents(atPath: url.path) else {
                    // Otherwise return nil
                    return nil
                }
                // Retrieve Attributes for URL
                let attributes = try? self.fileManager.attributesOfItem(atPath: url.path)
                // Return file with Data and optional Modification Date
                return (data, attributes?[.modificationDate] as? Date)
            }
        // Switch on SortMode
        switch sortMode {
        case .ascending, .descending:
            // Sort Files
            files.sort { lhs, rhs in
                // Verify both modification Dates are available
                guard let lhsDate = lhs.modificationDate, let rhsDate = rhs.modificationDate else {
                    // Otherwise return false
                    return false
                }
                // Switch on SortMode
                switch sortMode {
                case .ascending:
                    // Return descending order
                    return lhsDate > rhsDate
                case .descending:
                    // Return descending order
                    return lhsDate > rhsDate
                case .custom:
                    return false
                }
            }
        case .custom:
            break
        }
        // CompactMap Files to Storables
        var storables: [Storable] = files
            .compactMap { file in
                // Try to Decode File Data
                try? self.decoder.decode(Storable.self, from: file.data)
            }
        // Check if SortMode is custom
        if case .custom(let predicate) = sortMode {
            // Sort by custom predicate
            storables.sort(by: predicate)
        }
        // Return success
        return .success(storables)
    }
    
    /// Retrieve all CodableStorable that satisfy the given predicate
    /// - Parameters:
    ///   - sortMode: The SortMode. Default value `.descending`
    ///   - predicate: The predicate
    func getAll(
        sortMode: SortMode = .descending,
        where predicate: (Storable) -> Bool
    ) -> Result<[Storable], Error> {
        // Retrieve all and apply filter
        self.getAll().map { $0.filter(predicate) }
    }
    
}
