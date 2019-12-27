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
            // Try to make Storable URL with identifier
            url = try self.makeStorableURL(identifier: identifier)
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
            Self.ChangeEvent.deleted(container: self.container)
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
            // Try to make collection url
            url = try self.makeCollectionURL()
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
            Self.ChangeEvent.deleted(container: self.container)
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
    func delete(_ identifiers: [String]) -> [Result<Void, Error>] {
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
