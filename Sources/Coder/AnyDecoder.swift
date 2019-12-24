//
//  AnyDecoder.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 20.11.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - AnyDecoder

/// The AnyDecoder
public protocol AnyDecoder {
    
    /// Decode Type from Data
    ///
    /// - Parameters:
    ///   - type: The Decodable Type
    ///   - data: The Data
    /// - Returns: Decoded instance
    /// - Throws: If decoding fails
    func decode<D: Decodable>(_ type: D.Type, from data: Data) throws -> D
    
}

// MARK: - JSONDecoder AnyDecoder

extension JSONDecoder: AnyDecoder {}

// MARK: - PropertyListDecoder AnyDecoder

extension PropertyListDecoder: AnyDecoder {}
