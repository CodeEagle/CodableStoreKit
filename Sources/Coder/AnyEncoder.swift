//
//  AnyEncoder.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 20.11.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - AnyEncoder

/// The AnyEncoder
public protocol AnyEncoder {
    
    /// Encoder Value
    ///
    /// - Parameter value: The generic Value
    /// - Returns: Encoded Data representation
    /// - Throws: If encoding fails
    func encode<Value: Encodable>(_ value: Value) throws -> Data
    
}

// MARK: - JSONEncoder AnyEncoder

extension JSONEncoder: AnyEncoder {}

// MARK: - PropertyListEncoder AnyEncoder

extension PropertyListEncoder: AnyEncoder {}
