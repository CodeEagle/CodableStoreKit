//
//  CodableStore+Remove.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 07.12.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Remove

public extension CodableStore {
    
    /// Remove CodableStorable by identifier
    /// - Parameter identifier: The CodableStorable identifier that should be removed
    @discardableResult
    func remove(_ identifier: Storable.Identifier) -> Result<Void, Error> {
        // Verify Storable exists for identifier
        guard self.contains(identifier) else {
            // Otherwise return failure
            return .failure(.notFound(identifier))
        }
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
        do {
            // Try to remove item at url
            try self.fileManager.removeItem(at: url)
        } catch {
            // Return failure
            return .failure(.fileDeletionFailed(url, error))
        }
        // Clear directories if needed
        self.clearDirectoriesIfNeeded()
        // Emit removed event
        self.notificationCenter.emit(
            storableType: Storable.self,
            .removed(
                identifier: identifier,
                container: self.container
            )
        )
        // Return success
        return .success(())
    }
    
    /// Remove all saved CodableStorables
    @discardableResult
    func removeAll() -> Result<Void, Error> {
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
        do {
            // Try to remove item at url
            try self.fileManager.removeItem(at: url)
        } catch {
            // Return failure
            return .failure(.collectionDeletionFailed(url, error))
        }
        // Clear directories if needed
        self.clearDirectoriesIfNeeded()
        // Emit removed event
        self.notificationCenter.emit(
            storableType: Storable.self,
            .removedAll(
                container: self.container
            )
        )
        // Return success
        return .success(())
    }
    
    /// Remove all CodableStorables that satisfy the given predicate
    /// - Parameter predicate: The predicate
    @discardableResult
    func removeAll(where predicate: (Storable) -> Bool) -> [Result<Void, Error>] {
        // Retrieve all with predicate
        switch self.getAll(where: predicate) {
        case .success(let storables):
            // Remove Storables
            return self.remove(storables)
        case .failure(let error):
            // Return failure
            return [.failure(error)]
        }
    }
    
    /// Remove CodableStorables
    /// - Parameter identifiers: The CodableStorable identifiers that should be removed
    @discardableResult
    func remove<S: Sequence>(_ identifiers: S) -> [Result<Void, Error>] where S.Element == Storable.Identifier {
        // Remove identifiers
        identifiers.map(self.remove)
    }
    
    /// Remove CodableStorable
    /// - Parameter storable: The CodableStorable that should be removed
    @discardableResult
    func remove(_ storable: Storable) -> Result<Void, Error> {
        // Remove by identifier
        self.remove(storable.identifier)
    }
    
    /// Remove CodableStorables
    /// - Parameter storables: The Sequence of CodableStorables that should be removed
    @discardableResult
    func remove<S: Sequence>(_ storables: S) -> [Result<Void, Error>] where S.Element == Storable {
        // Remove Storables
        storables.map(self.remove)
    }
    
}

// MARK: - Clear Directories if needed

private extension CodableStore {
    
    /// Clear directories if needed
    func clearDirectoriesIfNeeded() {
        // Initialize remove if empty closure
        let removeIfEmpty: (URL) -> Void = { url in
            // Verfy content of directory is available for URL and paths are empty
            guard let paths = try? self.fileManager.contentsOfDirectory(atPath: url.path),
                paths.isEmpty else {
                    // Otherwise return
                    return
            }
            // Remove item at url
            try? self.fileManager.removeItem(at: url)
        }
        // Remove Collection-Directory if Empty
        (try? self.collectionURL().get()).flatMap(removeIfEmpty)
        // Remove Container-Directory if Empty
        (try? self.containerURL().get()).flatMap(removeIfEmpty)
    }
    
}
