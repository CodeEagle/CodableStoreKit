//
//  CodableStorable+Identifier.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 19.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - CodableStorable+Identifier

extension CodableStorable {
    
    /// The Identifier
    public var identifier: Identifier {
        return self[keyPath: Self.codableStoreIdentifier]
    }
    
}
