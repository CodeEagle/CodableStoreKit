//
//  CodableStoreContainer.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStoreContainer

/// The CodableStoreContainer
public struct CodableStoreContainer: Codable, Equatable, Hashable {
    
    // MARK: Properties
    
    /// The Container Name
    public var name: String
    
    /// The Full-Qualified-Name
    var fullQualifiedName: String {
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
    
    /// Retrieve DefaultCodableStoreContainer with suffix
    ///
    /// - Parameter suffix: The suffix
    /// - Returns: The default CodableStoreContainer
    static func `default`(_ suffix: String) -> CodableStoreContainer {
        return .init(name: "Default\(suffix)")
    }
    
}

// MARK: - ExpressibleByStringLiteral

extension CodableStoreContainer: ExpressibleByStringLiteral {
    
    /// The String Literal Type
    public typealias StringLiteralType = String
    
    /// Initializer with String Value
    ///
    /// - Parameter value: The String Value
    public init(stringLiteral value: String) {
        self.name = value
    }
    
}

// MARK: - ExpressibleByIntegerLiteral

extension CodableStoreContainer: ExpressibleByIntegerLiteral {
    
    /// The Integer Literal Type
    public typealias IntegerLiteralType = Int
    
    /// Initializer with Integer Value which will be converted to a String
    ///
    /// - Parameter value: The Integer Value
    public init(integerLiteral value: Int) {
        self.name = String(describing: value)
    }
    
}

// MARK: - CustomStringConvertible

extension CodableStoreContainer: CustomStringConvertible {
    
    /// String representation
    public var description: String {
        return self.fullQualifiedName
    }
    
}
