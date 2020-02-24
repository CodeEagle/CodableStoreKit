//
//  CodableStore+Error.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 07.12.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Error

public extension CodableStore {
    
    /// The CodableStore Error
    struct Error: Swift.Error {
        
        // MARK: Properties
        
        /// The failure reason
        public let failureReason: String
        
        /// The optional underlying Error
        public let underlyingError: Swift.Error?
        
        // MARK: Initializer
        
        /// Designated Initializer
        /// - Parameters:
        ///   - failureReason: The failure reason
        ///   - underlyingError: The optional underlying Error. Default value `nil`
        public init(
            failureReason: String,
            underlyingError: Swift.Error? = nil
        ) {
            self.failureReason = failureReason
            self.underlyingError = underlyingError
        }
        
    }
    
}

// MARK: - Error+Defaults

extension CodableStore.Error {
    
    /// Constructing URL failed Error
    /// - Parameter error: The Error
    static func constructingURLFailed(_ error: Error) -> Self {
        .init(
            failureReason: "Constructing URL for CodableStorable failed",
            underlyingError: error
        )
    }
    
    /// Encoding failed Error
    /// - Parameter error: The Error
    static func encodingFailed(_ error: Error) -> Self {
        .init(
            failureReason: "Encoding CodableStorable failed",
            underlyingError: error
        )
    }
    
    /// File creation failed Error
    /// - Parameter url: The URL
    static func fileCreationFailed(_ url: URL) -> Self {
        .init(
            failureReason: "Creating File for CodableStorable Data representation failed: \(url)"
        )
    }
    
    /// Not found Error
    /// - Parameter identifier: The optional Identifier
    static func notFound(_ identifier: Storable.Identifier? = nil) -> Self {
        if let identifier = identifier {
            return .init(
                failureReason: "CodableStorable for identifier: \(identifier) doesn't exists"
            )
        } else {
            return .init(
                failureReason: "CodableStorable not found"
            )
        }
    }
    
    /// File deletion failed Error
    /// - Parameters:
    ///   - url: The URL
    ///   - error: The Error
    static func fileDeletionFailed(_ url: URL, _ error: Error) -> Self {
        .init(
            failureReason: "Removing CodableStorable failed \(url)",
            underlyingError: error
        )
    }
    
    /// Collection deletion failed Error
    /// - Parameters:
    ///   - url: The URL
    ///   - error: The Error
    static func collectionDeletionFailed(_ url: URL, _ error: Error) -> Self {
        .init(
            failureReason: "Removing Collection failed \(url)",
            underlyingError: error
        )
    }
    
    /// File data unavailable Error
    /// - Parameter identifier: The Identifier
    static func fileDataUnavailable(_ identifier: Storable.Identifier) -> Self {
        .init(
            failureReason: "Data for CodableStorable is not available \(identifier)"
        )
    }
    
    /// Decoding failed Error
    /// - Parameter error: The Error
    static func decodingFailed(_ error: Error) -> Self {
        .init(
            failureReason: "Decoding CodableStorable failed",
            underlyingError: error
        )
    }
    
    /// Contents of directory unavailable Error
    /// - Parameters:
    ///   - url: The URL
    ///   - error: The Error
    static func contentsOfDirectoryUnavailable(_ url: URL, _ error: Error) -> Self {
        .init(
            failureReason: "Contents of Directory is not available \(url)",
            underlyingError: error
        )
    }
    
    /// Non matching predicate Error
    static func nonMatchingPredicate() -> Self {
        .init(
            failureReason: "No CodableStorable found for the given predicate"
        )
    }
    
    /// Encryption failed Error
    /// - Parameters:
    ///   - url: The URL
    ///   - error: The Error
    static func encryptionFailed(_ url: URL, _ error: Error) -> Self {
        .init(
            failureReason: "Unable to encrypt file: \(url)",
            underlyingError: error
        )
    }
    
}
