//
//  Coderable.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Coder

/// The Coder Typealias closure
public typealias Coder = (encoder: Encoderable, decoder: Decoderable)

// MARK: - Encoderable

/// The Encoderable Protocol
public protocol Encoderable {
    
    /// The File Extension
    var fileExtension: String { get }
    
    /// Encoder Value
    ///
    /// - Parameter value: The generic Value
    /// - Returns: Encoded Data representation
    /// - Throws: If encoding fails
    func encode<Value: Encodable>(_ value: Value) throws -> Data
    
}

extension JSONEncoder: Encoderable {
    
    /// The File Extension
    public var fileExtension: String {
        return "json"
    }
    
}

extension PropertyListEncoder: Encoderable {
    
    /// The File Extension
    public var fileExtension: String {
        return "plist"
    }
    
}

// MARK: - Decoderable

/// The Decoderable Protocol
public protocol Decoderable {
    
    /// Decode Type from Data
    ///
    /// - Parameters:
    ///   - type: The Decodable Type
    ///   - data: The Data
    /// - Returns: Decoded instance
    /// - Throws: If decoding fails
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
    
}

extension JSONDecoder: Decoderable {}

extension PropertyListDecoder: Decoderable {}
