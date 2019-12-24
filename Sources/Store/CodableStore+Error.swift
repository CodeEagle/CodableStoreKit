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
        public init(failureReason: String,
                    underlyingError: Swift.Error? = nil) {
            self.failureReason = failureReason
            self.underlyingError = underlyingError
        }
        
    }
    
}

// MARK: - Defaults

extension CodableStore.Error {
    
    static func constructingURLFailed(_ error: Error) -> Self {
        .init(
            failureReason: "Constructing URL for CodableStorable failed",
            underlyingError: error
        )
    }
    
    static func encodingFailed(_ error: Error) -> Self {
        .init(
            failureReason: "Encoding CodableStorable failed",
            underlyingError: error
        )
    }
    
    static func fileCreationFailed(_ url: URL) -> Self {
        .init(
            failureReason: "Creating File for CodableStorable Data representation failed: \(url)"
        )
    }
    
    static func notFound(_ identifier: String) -> Self {
        .init(
            failureReason: "Storable for identifier: \(identifier) doesn't exists"
        )
    }
    
    static func fileDeletionFailed(_ url: URL, _ error: Error) -> Self {
        .init(
            failureReason: "Removing CodableStorable failed \(url)",
            underlyingError: error
        )
    }
    
    static func collectionDeletionFailed(_ url: URL, _ error: Error) -> Self {
        .init(
            failureReason: "Removing Collection failed \(url)",
            underlyingError: error
        )
    }
    
    static func fileDataUnavailable(_ identifier: String) -> Self {
        .init(
            failureReason: "Data for CodableStorable is not available \(identifier)"
        )
    }
    
    static func decodingFailed(_ error: Error) -> Self {
        .init(
            failureReason: "Decoding CodableStorable failed",
            underlyingError: error
        )
    }
    
    static func contentsOfDirectoryUnavailable(_ url: URL, _ error: Error) -> Self {
        .init(
            failureReason: "Contents of Directory is not available \(url)",
            underlyingError: error
        )
    }
    
    static func nonMatchingPredicate() -> Self {
        .init(
            failureReason: "No CodableStorable found for the given predicate"
        )
    }
    
}
