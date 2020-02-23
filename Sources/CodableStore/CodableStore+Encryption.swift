//
//  CodableStore+Encryption.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 27.12.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

#if !os(macOS)

// MARK: - Encrypt

public extension CodableStore {
    
    /// Encrypt saved CodableStorables
    /// - Parameters:
    ///   - protectionLevel: The encryption URLFileProtection Level
    ///   - predicate: The optional filter predicate closure. Default value `nil`
    @available(iOS 9.0, *)
    @discardableResult
    func encrypt(
        protectionLevel: URLFileProtection,
        where predicate: ((Storable) -> Bool)? = nil
    ) -> [Result<Void, Error>] {
        // Declare URL
        let url: URL
        do {
            // Try to make collection url
            url = try self.makeCollectionURL()
        } catch {
            // Return failure
            return [.failure(.constructingURLFailed(error))]
        }
        // Declare paths String Array
        var paths: [String]
        do {
            // Try to retrieve contents of directory at URL
            paths = try self.fileManager.contentsOfDirectory(atPath: url.path)
        } catch {
            // Return failure
            return [.failure(.contentsOfDirectoryUnavailable(url, error))]
        }
        // Check if a predicate filter is available
        if let predicate = predicate {
            // Filter Paths
            paths = paths.filter { path in
                // Initialize URL by appending URL with path
                let url = url.appendingPathComponent(path)
                // Verify Data is available at Path
                guard let data = self.fileManager.contents(atPath: url.path) else {
                    // Otherwise return false
                    return false
                }
                // Verify Data can be decoded to a Storable
                guard let storable = try? self.decoder.decode(Storable.self, from: data) else {
                    // Otherwise return false
                    return false
                }
                // Return result of predicate filter closure
                return predicate(storable)
            }
        }
        // Return mapped Paths
        return paths.map { path in
            // Initialize URL by appending URL with path
            let url = url.appendingPathComponent(path)
            do {
                // Try to set resource value with protection level
                try (url as NSURL).setResourceValue(
                    protectionLevel,
                    forKey: .fileProtectionKey
                )
                // Return success
                return .success(())
            } catch {
                // Return failure
                return .failure(.encryptionFailed(url, error))
            }
        }
    }
    
}

#endif
