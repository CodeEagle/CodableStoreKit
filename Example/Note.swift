//
//  Note.swift
//  Example
//
//  Created by Sven Tiigi on 24.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation
import CodableStoreKit

// MARK: - Note

/// A Note
struct Note {
    
    // MARK: Properties
    
    /// The Identifier
    let id: String
    
    /// The created at Date
    let createdAt: Date
    
    /// The content
    let content: String
    
    // MARK: Initializer
    
    /// Designated Initializer
    /// - Parameters:
    ///   - id: The Identifier. Default value `UUIDv4`
    ///   - createdAt: The created at Date. Default value `.init()`
    ///   - content: The content
    init(
        id: String = UUID().uuidString,
        createdAt: Date = .init(),
        content: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.content = content
    }
    
}

// MARK: - CodableStorable

extension Note: CodableStorable {
    
    /// The CodableStore unique Identifier KeyPath
    static var codableStoreIdentifier: KeyPath<Note, String> = \.id
    
}
