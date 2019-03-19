//
//  CodableStoreObservedChange.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 19.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

/// The CodableStoreObservedChange
public enum CodableStoreObservedChange<Storable: CodableStorable> {
    /// Saved CodableStorable in CodableStoreContainer
    case saved(storable: Storable, container: CodableStoreContainer)
    /// Deleted CodableStorable in CodableStoreContainer
    case deleted(storable: Storable, container: CodableStoreContainer)
}

// MARK: - Computed Properties

public extension CodableStoreObservedChange {
    
    /// The CodableStorable
    var storable: Storable {
        // Switch on self
        switch self {
        case .saved(let storable, _):
            return storable
        case .deleted(let storable, _):
            return storable
        }
    }
    
    /// The CodableStoreContainer
    var container: CodableStoreContainer {
        // Switch on self
        switch self {
        case .saved(_, let container):
            return container
        case .deleted(_, let container):
            return container
        }
    }
    
}
