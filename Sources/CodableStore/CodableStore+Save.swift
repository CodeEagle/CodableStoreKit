//
//  CodableStore+Save.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 07.12.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Save

public extension CodableStore {
    
    /// Save CodableStorable
    /// - Parameter storable: The CodableStorable that should be saved
    @discardableResult
    func save(_ storable: Storable) -> Result<Storable, Error> {
        // Declare URL
        let url: URL
        do {
            // Try to retrieve the Storable URL
            url = try self.url(for: storable)
        } catch {
            // Return failure
            return .failure(.constructingURLFailed(error))
        }
        // Declare Data
        let data: Data
        do {
            // Try to encode Storable to Data
            data = try self.encoder.encode(storable)
        } catch {
            // Return failure
            return .failure(.encodingFailed(error))
        }
        // Create file for Storable URL and Data
        let createFileResult = self.fileManager.createFile(
            atPath: url.path,
            contents: data,
            attributes: [
                .creationDate: self.creationDate(storable) ?? .init(),
                .modificationDate: Date()
            ]
        )
        // Verify creating file succeeded
        guard createFileResult else {
            // Otherwise return failure
            return .failure(.fileCreationFailed(url))
        }
        // Emit saved event
        self.notificationCenter.emit(
            .saved(
                storable: storable,
                container: self.container
            )
        )
        // Return success
        return .success(storable)
    }
    
    /// Save CodableStorables
    /// - Parameter storables: The Array of CodableStorables that should be saved
    @discardableResult
    func save(_ storables: [Storable]) -> [Result<Storable, Error>] {
        // Save Storables
        storables.map(self.save)
    }
    
}
