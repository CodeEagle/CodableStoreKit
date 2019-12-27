//
//  CodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 20.11.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStore

/// The CodableStore
public struct CodableStore<Storable: CodableStorable> {
    
    // MARK: Properties
    
    /// The FileManager
    let fileManager: FileManager
    
    /// The Encoder
    let encoder: AnyEncoder
    
    /// The Decoder
    let decoder: AnyDecoder
    
    /// The CodableStoreNotificationCenter
    let notificationCenter: CodableStoreNotificationCenter
    
    /// The Container
    public let container: CodableStoreContainer
    
    /// The FileSystem URL
    public var fileSystemURL: URL? {
        try? self.makeCollectionURL()
    }
    
    // MARK: Initializer
    
    /// Designated Initializer
    /// - Parameters:
    ///   - fileManager: The FileManager. Default value `.default`
    ///   - encoder: The Encoder. Default value `JSONEncoder()`
    ///   - decoder: The Decoder. Default value `JSONDecoder()`
    ///   - notificationCenter: The CodableStoreNotificationCenter. Default value `.default`
    ///   - container: The Container. Default value `.default`
    public init(
        fileManager: FileManager = .default,
        encoder: AnyEncoder = JSONEncoder(),
        decoder: AnyDecoder = JSONDecoder(),
        notificationCenter: CodableStoreNotificationCenter = .default,
        container: CodableStoreContainer = .default
    ) {
        self.fileManager = fileManager
        self.encoder = encoder
        self.decoder = decoder
        self.notificationCenter = notificationCenter
        self.container = container
    }
    
}

// MARK: - Equatable

extension CodableStore: Equatable {
    
    /// Returns a Boolean value indicating whether two CodableStores are equal.
    ///
    /// - Parameters:
    ///   - lhs: A CodableStore to compare.
    ///   - rhs: Another CodableStore to compare.
    public static func == (
        lhs: CodableStore<Storable>,
        rhs: CodableStore<Storable>
    ) -> Bool {
        lhs.fileManager === rhs.fileManager
            && lhs.notificationCenter === rhs.notificationCenter
            && lhs.container == rhs.container
    }
    
}

// MARK: - Make URL

extension CodableStore {
    
    /// Make Storable URL with identifier
    /// - Parameter identifier: The identifier value
    func makeStorableURL(identifier: Storable.Identifier) throws -> URL {
        // Make collection url and append identifier
        try self.makeCollectionURL().appendingPathComponent(identifier)
    }
    
    /// Make Collection URL
    func makeCollectionURL() throws -> URL {
        // Initialize URL via appending collection name to container url
        let url = try self.makeContainerURL()
            .appendingPathComponent(Storable.codableStoreCollectionName)
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
        return url.appendingPathComponent(self.container.name)
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
