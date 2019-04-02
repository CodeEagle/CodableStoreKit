//
//  CodableStoreObserverIntent.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 24.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - CodableStoreObserverIntent

/// The CodableStore Observer Intent
public enum CodableStoreObserverIntent<Storable: CodableStorable> {
    /// Matches Identifier
    case identifier(Storable.Identifier)
    /// Matches Predicate
    case predicate((Storable) -> Bool)
    /// Matches all
    case all
}
