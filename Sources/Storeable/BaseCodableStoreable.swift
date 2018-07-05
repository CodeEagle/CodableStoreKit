//
//  BaseCodableStoreable.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 05.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - BaseCodableStoreable

/// The BaseCodableStoreable Protocol
public protocol BaseCodableStoreable: Codable {
    
    // swiftlint:disable type_name
    /// The associatedtype ID
    associatedtype ID: Hashable
    // swiftlint:enable type_name
    
    /// The CodableStore unique identifier Key Path
    static var codableStoreIdentifier: KeyPath<Self, ID> { get }
    
    /// The CodableStore collection name
    static var codableStoreCollectionName: String { get }
    
    /// The CodableStore Coder
    static var codableStoreCoder: Coder { get }
    
}

// MARK: - BaseCodableStoreable Default Implementation

public extension BaseCodableStoreable {
    
    /// The CodableStore collection name
    static var codableStoreCollectionName: String {
        return String(describing: type(of: self))
    }
    
    /// The CodableStore Coder
    static var codableStoreCoder: Coder {
        return (JSONEncoder(), JSONDecoder())
    }
    
    /// The CodeableStore Identifier Value
    var codableStoreIdentifierValue: ID {
        return self[keyPath: Self.codableStoreIdentifier]
    }
    
}
