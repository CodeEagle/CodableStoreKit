//
//  FileManagerCodableStoreEngineCoder.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - FileManagerCodableStoreEngineEncoder

/// The FileManagerCodableStoreEngineEncoder
public protocol FileManagerCodableStoreEngineEncoder {
    
    /// Encoder Value
    ///
    /// - Parameter value: The generic Value
    /// - Returns: Encoded Data representation
    /// - Throws: If encoding fails
    func encode<Value: Encodable>(_ value: Value) throws -> Data
    
}

// MARK: - JSONEncoder+FileManagerCodableStoreEngineEncoder

extension JSONEncoder: FileManagerCodableStoreEngineEncoder {}

// MARK: - FileManagerCodableStoreEngineDecoder

/// The FileManagerCodableStoreEngineDecoder
public protocol FileManagerCodableStoreEngineDecoder {
    
    /// Decode Type from Data
    ///
    /// - Parameters:
    ///   - type: The Decodable Type
    ///   - data: The Data
    /// - Returns: Decoded instance
    /// - Throws: If decoding fails
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
    
}

// MARK: - JSONDecoder+FileManagerCodableStoreEngineDecoder

extension JSONDecoder: FileManagerCodableStoreEngineDecoder {}
