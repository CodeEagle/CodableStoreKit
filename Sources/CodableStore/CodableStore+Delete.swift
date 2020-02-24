//
//  CodableStore+Delete.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 07.12.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Delete

public extension CodableStore {
    
    /// Delete CodableStorable by identifier
    /// - Parameter identifier: The CodableStorable identifier that should be deleted
    @discardableResult
    func delete(_ identifier: Storable.Identifier) -> Result<Void, Error> {
        // Verify Storable exists for identifier
        guard self.exists(identifier) else {
            // Otherwise return failure
            return .failure(.notFound(identifier))
        }
        // Declare URL
        let url: URL
        do {
            // Try to retrieve the Storable URL for identifier
            url = try self.url(for: identifier)
        } catch {
            // Return failure
            return .failure(.constructingURLFailed(error))
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
        // Emit deleted event
        self.notificationCenter.emit(
            storableType: Storable.self,
            .deleted(
                identifier: identifier,
                container: self.container
            )
        )
        // Return success
        return .success(())
    }
    
    /// Delete all saved CodableStorables
    @discardableResult
    func deleteAll() -> Result<Void, Error> {
        // Declare URL
        let url: URL
        do {
            // Try to retrieve the collection url
            url = try self.collectionURL()
        } catch {
            // Return failure
            return .failure(.constructingURLFailed(error))
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
        // Emit deleted event
        self.notificationCenter.emit(
            storableType: Storable.self,
            .deletedAll(
                container: self.container
            )
        )
        // Return success
        return .success(())
    }
    
    /// Delete all CodableStorables that satisfy the given predicate
    /// - Parameter predicate: The predicate
    @discardableResult
    func deleteAll(where predicate: (Storable) -> Bool) -> [Result<Void, Error>] {
        // Retrieve all with predicate
        switch self.getAll(where: predicate) {
        case .success(let storables):
            // Delete Storables
            return self.delete(storables)
        case .failure(let error):
            // Return failure
            return [.failure(error)]
        }
    }
    
    /// Delete CodableStorables
    /// - Parameter identifiers: The CodableStorable identifiers that should be deleted
    @discardableResult
    func delete(_ identifiers: [Storable.Identifier]) -> [Result<Void, Error>] {
        // Delete identifiers
        identifiers.map(self.delete)
    }
    
    /// Delete CodableStorable
    /// - Parameter storable: The CodableStorable that should be deleted
    @discardableResult
    func delete(_ storable: Storable) -> Result<Void, Error> {
        // Delete by identifier
        self.delete(storable.identifier)
    }
    
    /// Delete CodableStorables
    /// - Parameter storables: The Array of CodableStorables that should be deleted
    @discardableResult
    func delete(_ storables: [Storable]) -> [Result<Void, Error>] {
        // Delete Storables
        storables.map(self.delete)
    }
    
}

// MARK: - Clear Directories if needed

private extension CodableStore {
    
    /// Clear directories if needed
    func clearDirectoriesIfNeeded() {
        // Initialize delete if empty closure
        let deleteIfEmpty: (URL) -> Void = { url in
            // Verfy content of directory is available for URL and paths are empty
            guard let paths = try? self.fileManager.contentsOfDirectory(atPath: url.path),
                paths.isEmpty else {
                    // Otherwise return
                    return
            }
            // Remove item at url
            try? self.fileManager.removeItem(at: url)
        }
        // Delete Collection-Directory if Empty
        (try? self.collectionURL()).flatMap(deleteIfEmpty)
        // Delete Container-Directory if Empty
        (try? self.containerURL()).flatMap(deleteIfEmpty)
    }
    
}
