//
//  CodableStoreContainer.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - CodableStoreContainer

/// The CodableStoreContainer
public struct CodableStoreContainer: Codable, Equatable, Hashable {
    
    // MARK: Properties
    
    /// The Container Name
    public var name: String
    
    /// The Full-Qualified-Name
    public var fullQualifiedName: String {
        return "\(self.name)-CodableStoreContainer"
    }
    
    // MARK: Initializer
    
    /// Designated Initializer
    ///
    /// - Parameter name: The name
    public init(name: String) {
        self.name = name
    }
}

// MARK: - DefaultCodableStoreContainer

public extension CodableStoreContainer {
    
    /// The DefaultCodableStoreContainer
    static var `default` = CodableStoreContainer(name: "Default")
    
}

// MARK: - ExpressibleByStringLiteral

extension CodableStoreContainer: ExpressibleByStringLiteral {
    
    /// Initializer with String Value
    ///
    /// - Parameter value: The String Value
    public init(stringLiteral value: String) {
        self.name = value
    }
    
}

// MARK: - ExpressibleByIntegerLiteral

extension CodableStoreContainer: ExpressibleByIntegerLiteral {
    
    /// Initializer with Integer Value which will be converted to a String
    ///
    /// - Parameter value: The Integer Value
    public init(integerLiteral value: Int) {
        self.name = .init(value)
    }
    
}

// MARK: - ExpressibleByFloatLiteral

extension CodableStoreContainer: ExpressibleByFloatLiteral {
    
    /// Creates an instance initialized to the specified floating-point value.
    ///
    /// - Parameter value: The value to create.
    public init(floatLiteral value: Double) {
        self.name = .init(value)
    }
    
}

// MARK: - CustomStringConvertible

extension CodableStoreContainer: CustomStringConvertible {
    
    /// String representation
    public var description: String {
        return self.fullQualifiedName
    }
    
}
