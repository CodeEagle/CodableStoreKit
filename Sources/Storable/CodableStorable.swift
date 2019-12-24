//
//  CodableStorable.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 20.11.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStorable

/// The CodableStorable
public protocol CodableStorable: Codable {
    
    /// The CodableStore unique Identifier KeyPath
    static var codableStoreIdentifier: KeyPath<Self, String> { get }
    
    /// The CodableStore Collection Name
    static var codableStoreCollectionName: String { get }
    
}

// MARK: - Default Implementation

public extension CodableStorable {
    
    /// The CodableStore Collection Name
    static var codableStoreCollectionName: String {
        return .init(describing: type(of: self))
    }
    
}

// MARK: - (Internal) CodableStorable+Identifier

extension CodableStorable {
    
    /// The identifier String value
    var identifier: String {
        self[keyPath: Self.codableStoreIdentifier]
    }
    
}
