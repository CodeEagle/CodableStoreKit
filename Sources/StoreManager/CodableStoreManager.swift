//
//  CodableStoreManager.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - CodableStoreManager

/// The CodableStoreManager
public final class CodableStoreManager {
    
    /// The EngineProvider Typealias
    public typealias EngineProvider = (Codable.Type, CodableStoreContainer) -> CodableStoreEngine
    
    /// The Engine Provider
    public static var engineProvider: EngineProvider = { _, _  in
        FileManagerCodableStoreEngine()
    }
    
}
