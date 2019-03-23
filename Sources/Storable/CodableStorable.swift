//
//  CodableStorable.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - CodableStorable

/// The CodableStorable
public protocol CodableStorable: Codable {
    
    /// The Identifier associatedtype which is constrainted to `StringRepresentable`
    associatedtype Identifier: StringRepresentable = String
    
    /// The CodableStore unique Identifier KeyPath
    static var codableStoreIdentifier: KeyPath<Self, Identifier> { get }
    
    /// The CodableStore Collection Name
    static var codableStoreCollectionName: StringRepresentable { get }
    
}

// MARK: - Default Implementation

public extension CodableStorable {
    
    /// The CodableStore Collection Name
    static var codableStoreCollectionName: StringRepresentable {
        return String(describing: type(of: self))
    }
    
}
