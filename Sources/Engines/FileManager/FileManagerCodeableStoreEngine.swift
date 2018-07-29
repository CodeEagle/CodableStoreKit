//
//  FileManagerCodeableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - FileManagerCodeableStoreEngine

/// The FileManagerCodeableStoreEngine
class FileManagerCodeableStoreEngine<Object: BaseCodableStoreable>: InitializableCodableStoreEngine {
    
    /// The CodableStoreContainer
    let container: CodableStoreContainer
    
    /// The FileManager
    let fileManager: FileManager
    
    /// Designated Initializer
    ///
    /// - Parameters:
    ///   - container: The Container
    ///   - fileManager: The FileManager
    init(container: CodableStoreContainer = .default,
         fileManager: FileManager = .default) {
        self.container = container
        self.fileManager = fileManager
    }
    
    required init(container: CodableStoreContainer) {
        self.container = container
        self.fileManager = .default
    }
    
}

// MARK: - EngineError

extension FileManagerCodeableStoreEngine {
    
    /// The EngineError
    enum EngineError: Error {
        /// Saving failed for Object
        case saveFailed(Object)
        /// Object with id on path not found
        case notFound(identifier: Object.ID, path: String)
    }
    
}

// MARK: - WriteableCodeableStoreEngine

extension FileManagerCodeableStoreEngine: WriteableCodableStoreEngine {
    
    /// Save Object
    ///
    /// - Parameter object: The object to save
    /// - Returns: The saved object
    /// - Throws: If saving fails
    @discardableResult
    func save(_ object: Object) throws -> Object {
        // Retrieve Path for Object
        let path = try self.getPath(object)
        // Try to encode Object
        let data = try Object.codableStoreCoder.encoder.encode(object)
        // Create File at path with data
        let createFileResult = self.fileManager.createFile(
            atPath: path,
            contents: data,
            attributes: nil
        )
        // Check if file creation failed
        if !createFileResult {
            // Throw error
            throw EngineError.saveFailed(object)
        }
        // Return saved object
        return object
    }
    
    /// Delete Object via ID
    ///
    /// - Parameter identifier: The object identifier
    /// - Returns: The deleted object
    /// - Throws: If deleting fails
    @discardableResult
    func delete(identifier: Object.ID) throws -> Object {
        // Retrieve object
        let object = try self.get(identifier: identifier)
        // Retrieve Path for identifier
        let path = try self.getPath(identifier)
        // Try to remove object at path
        try self.fileManager.removeItem(atPath: path)
        // Clear Directories if needed
        self.clearDirectoriesIfNeeded()
        // Return deleted object
        return object
    }
    
}

// MARK: - ReadableCodeableStoreEngine

extension FileManagerCodeableStoreEngine: ReadableCodableStoreEngine {
    
    /// Retrieve Object via ID
    ///
    /// - Parameter identifier: The identifier
    /// - Returns: The corresponding Object
    /// - Throws: If retrieving fails
    func get(identifier: Object.ID) throws -> Object {
        // Retrieve Path for identifier
        let path = try self.getPath(identifier)
        // Unwrap data for contents at path
        guard let data = self.fileManager.contents(atPath: path) else {
            // Unable to find Object with identifier at path
            throw EngineError.notFound(identifier: identifier, path: path)
        }
        // Return decoded Object
        return try Object.codableStoreCoder.decoder.decode(Object.self, from: data)
    }
    
    /// Retrieve all Objects in Collection
    ///
    /// - Returns: The Objects in the Collection
    /// - Throws: If retrieving fails
    func getCollection() throws -> [Object] {
        // Retrieve Collection URL
        let collectionURL = try self.getCollectionURL()
        // Retrieve paths at collection URL
        let paths = try self.fileManager.contentsOfDirectory(atPath: collectionURL.path)
        // Return compacted paths to decoded object
        return paths.compactMap {
            // Append Path to collectionURL
            let url = collectionURL.appendingPathComponent($0)
            // Retrieve data at Path
            guard let data = self.fileManager.contents(atPath: url.path) else {
                // No data available return nil
                return nil
            }
            // Return decoded object from DataDictionary
            return try? Object.codableStoreCoder.decoder.decode(Object.self, from: data)
        }
    }
    
}

// MARK: - URL / Path / Directory Helper

extension FileManagerCodeableStoreEngine {
    
    /// Retrieve Store Path for Object
    ///
    /// - Parameter object: The Object
    /// - Returns: The absolute store path
    /// - Throws: If retrieving path fails
    func getPath(_ object: Object) throws -> String {
        // Return Path with identifier
        return try self.getPath(object.codableStoreIdentifierValue)
    }
    
    /// Retrieve Store Path for Object identifier
    ///
    /// - Parameter object: The Object identifier
    /// - Returns: The absolute store path
    /// - Throws: If retrieving Path fails
    func getPath(_ identifier: Object.ID) throws -> String {
        // Return Path appended to Collection URL
        let fileName = "\(identifier.hashValue).\(Object.codableStoreCoder.encoder.fileExtension)"
        return try self.getCollectionURL().appendingPathComponent(fileName).path
    }
    
    /// Retrieve Container URL
    ///
    /// - Returns: The Container URL
    /// - Throws: If retrieving URL fails
    func getContainerURL() throws -> URL {
        return try self.fileManager
            .getSearchPathDirectoryURL()
            .appendingPathComponent(self.container.fullQualifiedName)
    }
    
    /// Retrieve Collection URL
    ///
    /// - Returns: The Collection URL
    /// - Throws: If retrieving URL fails
    func getCollectionURL() throws -> URL {
        // Initialize URL via appending collection name to container url
        let url = try self.getContainerURL()
            .appendingPathComponent(Object.codableStoreCollectionName)
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

    /// Clear Directories if Needed
    func clearDirectoriesIfNeeded() {
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
        (try? self.getCollectionURL()).flatMap(deleteIfEmpty)
        // Delete Container-Directory if Empty
        (try? self.getContainerURL()).flatMap(deleteIfEmpty)        
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
