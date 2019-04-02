//
//  CodableStoreEngineError.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 18.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - CodableStoreEngineError

/// The CodableStoreEngineError
public enum CodableStoreEngineError<Storable: CodableStorable>: Error {
    /// Saving failed for Storable
    case savingFailed(storable: Storable, container: CodableStoreContainer)
    /// CodableStorable not found for Identifier
    case notFound(identifier: Storable.Identifier)
}
