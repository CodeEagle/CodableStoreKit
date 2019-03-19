//
//  FileManagerCodableStoreEngine.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - FileManagerCodableStoreEngine

/// The FileManagerCodableStoreEngine
public final class FileManagerCodableStoreEngine {
    
    // MARK: Properties
    
    /// The FileManager
    let fileManager: FileManager
    
    /// The FileManagerCodableStoreEngine Encoder
    let encoder: FileManagerCodableStoreEngineEncoder
    
    /// The FileManagerCodableStoreEngine Decoder
    let decoder: FileManagerCodableStoreEngineDecoder
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameters:
    ///   - fileManager: The FileManager. Default value `default`
    ///   - encoder: The FileManagerCodableStoreEngine Encoder. Default value `JSONEncoder`
    ///   - decoder: The FileManagerCodableStoreEngine Decoder. Default value `JSONDecoder`
    init(fileManager: FileManager = .default,
         encoder: FileManagerCodableStoreEngineEncoder = JSONEncoder(),
         decoder: FileManagerCodableStoreEngineDecoder = JSONDecoder()) {
        self.fileManager = fileManager
        self.encoder = encoder
        self.decoder = decoder
    }
    
}

extension FileManagerCodableStoreEngine: CodableStoreEngine {
    
    /// Save CodableStorable
    ///
    /// - Parameter storable: The CodableStorable to save
    /// - Returns: The saved CodableStorable
    /// - Throws: If saving fails
    @discardableResult
    public func save<Storable: CodableStorable>(_ storable: Storable,
                                                in container: CodableStoreContainer) throws -> Storable {
        // Try to retrieve Path
        let path = try self.getPath(
            type: Storable.self,
            identifier: storable.identifier,
            container: container
        )
        // Try to encode Storable
        let data = try self.encoder.encode(storable)
        // Create File at Path for Data
        let createResult = self.fileManager.createFile(
            atPath: path,
            contents: data,
            attributes: nil
        )
        // Check if create result is a failure
        if !createResult {
            // Throw saving failed error
            throw CodableStoreEngineError<Storable>.savingFailed(
                storable: storable,
                container: container
            )
        }
        // Return saved Storable
        return storable
    }
    
    /// Delete CodableStorable via Identifier
    ///
    /// - Parameter identifier: The CodableStorable Identifier
    /// - Returns: The deleted CodableStorable
    /// - Throws: If deleting fails
    @discardableResult
    public func delete<Storable: CodableStorable>(_ identifier: Storable.Identifier,
                                                  in container: CodableStoreContainer) throws -> Storable {
        // Try to retrieve Storable for Identifier in Container
        let storable: Storable = try self.get(identifier: identifier, in: container)
        // Try to retrieve Path
        let path = try self.getPath(
            type: Storable.self,
            identifier: storable.identifier,
            container: container
        )
        // Try to remove Item at Path
        try self.fileManager.removeItem(atPath: path)
        // Clear Directories if needed
        self.clearDirectoriesIfNeeded(
            collectionName: Storable.codableStoreCollectionName,
            container: container
        )
        // Return deleted Storable
        return storable
    }
    
    /// Delete all CodableStorables in Collection
    ///
    /// - Returns: The deleted CodableStorables
    @discardableResult
    public func deleteCollection<Storable: CodableStorable>(in container: CodableStoreContainer) throws -> [Storable] {
        // Try to retrieve Collection
        let storableCollection: [Storable] = try self.getCollection(in: container)
        // Try to retrieve Collection URL
        let collectionURL = try self.getCollectionURL(
            collectionName: Storable.codableStoreCollectionName,
            container: container
        )
        // Try to remove Item at URL
        try self.fileManager.removeItem(at: collectionURL)
        // Return deleted Storable Collection
        return storableCollection
    }
    
    /// Retrieve CodableStorable via Identifier
    ///
    /// - Parameter identifier: The Ientifier
    /// - Returns: The corresponding CodableStorable
    /// - Throws: If retrieving fails
    public func get<Storable: CodableStorable>(identifier: Storable.Identifier,
                                               in container: CodableStoreContainer) throws -> Storable {
        // Try to retrieve Path
        let path = try self.getPath(
            type: Storable.self,
            identifier: identifier,
            container: container
        )
        // Retrieve Data at Path
        guard let data = self.fileManager.contents(atPath: path) else {
            // Throw not found Error
            throw CodableStoreEngineError<Storable>.notFound(identifier: identifier)
        }
        // Try to decode Storable
        let storable = try self.decoder.decode(Storable.self, from: data)
        // Return decoded Storable
        return storable
    }
    
    /// Retrieve all CodableStorables in Collection
    ///
    /// - Returns: The CodableStorables in the Collection
    /// - Throws: If retrieving fails
    public func getCollection<Storable: CodableStorable>(in container: CodableStoreContainer) throws -> [Storable] {
        // Try to retrieve Collection URL
        let collectionURL = try self.getCollectionURL(
            collectionName: Storable.codableStoreCollectionName,
            container: container
        )
        // Retrieve Paths at Collection URL
        let paths = try self.fileManager.contentsOfDirectory(atPath: collectionURL.path)
        // Map Paths to Storables
        return paths.compactMap { path in
            // Initialize URL by appending Collection URL with Path
            let url = collectionURL.appendingPathComponent(path)
            // Retrieve Data at Path
            guard let data = self.fileManager.contents(atPath: url.path) else {
                // Data is unavailable return nil
                return nil
            }
            // Try to decode Data to Storable
            return try? self.decoder.decode(Storable.self, from: data)
        }
    }
    
}

// MARK: - URL / Path / Directory Helper

extension FileManagerCodableStoreEngine {
    
    /// Retrieve Path for Identifier and CodableStorable Type in CodableStoreContainer
    ///
    /// - Parameters:
    ///   - type: The CodableStorable Type
    ///   - identifier: The CodableStorable Identifier
    ///   - container: The CodableStoreContainer
    /// - Returns: The Path
    /// - Throws: If Path is unavailable
    func getPath<Storable: CodableStorable>(type: Storable.Type,
                                            identifier: StringRepresentable,
                                            container: CodableStoreContainer) throws -> String {
        // Retrieve URL for Collection in Container and append Identifier
        return try self.getCollectionURL(
            collectionName: Storable.codableStoreCollectionName,
            container: container
        ).appendingPathComponent(identifier.stringRepresentation).path
    }
    
    /// Retrieve Container URL for CodableStoreContainer
    ///
    /// - Parameter container: The CodableStoreContainer
    /// - Returns: The URL
    /// - Throws: If URL is unavailable
    func getContainerURL(container: CodableStoreContainer) throws -> URL {
        return try self.fileManager
            .getSearchPathDirectoryURL()
            .appendingPathComponent(container.fullQualifiedName)
    }

    /// Retrieve Collection URL for CollectionName and CodableStoreContainer
    ///
    /// - Parameters:
    ///   - collectionName: The CollectionName
    ///   - container: The CodableStoreContainer
    /// - Returns: The URL
    /// - Throws: If URL is unavailable
    func getCollectionURL(collectionName: StringRepresentable,
                          container: CodableStoreContainer) throws -> URL {
        // Initialize URL via appending collection name to container url
        let url = try self.getContainerURL(container: container)
            .appendingPathComponent(collectionName.stringRepresentation)
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
    
    /// Clear Directories if needed
    ///
    /// - Parameters:
    ///   - collectionName: The CollectionName
    ///   - container: The CodableStoreContainer
    func clearDirectoriesIfNeeded(collectionName: StringRepresentable,
                                  container: CodableStoreContainer) {
        // Initialize delete if empty closure
        let deleteIfEmpty = { [weak self] (url: URL) in
            // Verify paths at url is empty
            if let paths = try? self?.fileManager
                .contentsOfDirectory(atPath: url.path),
                paths?.isEmpty == true {
                // Remove item at url
                try? self?.fileManager.removeItem(at: url)
            }
        }
        // Delete Collection-Directory if Empty
        (try? self.getCollectionURL(collectionName: collectionName, container: container)).flatMap(deleteIfEmpty)
        // Delete Container-Directory if Empty
        (try? self.getContainerURL(container: container)).flatMap(deleteIfEmpty)
    }
    
}

// MARK: - FileManager SearchPathDirectory

private extension FileManager {
    
    /// Retrieve the SearchPathDirectory URL
    ///
    /// - Returns: The SearchPathDirectory URL
    /// - Throws: If retrieving URL fails
    func getSearchPathDirectoryURL() throws -> URL {
        // Declare searchPathDirectory
        let searchPathDirectory: FileManager.SearchPathDirectory
        #if (tvOS)
        // tvOS only offers cachesDirectory
        searchPathDirectory = .cachesDirectory
        #else
        // Other Platforms allow the documentDirectory
        searchPathDirectory = .documentDirectory
        #endif
        // Return SearchPathDirectory URL
        return try self.url(
            for: searchPathDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }
    
}
