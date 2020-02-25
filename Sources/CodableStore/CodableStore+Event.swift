//
//  CodableStore+Event.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 22.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Event

public extension CodableStore {
    
    /// The CodableStore Event
    enum Event {
        /// Saved CodableStorable in CodableStoreContainer
        case saved(
            storable: Storable,
            container: CodableStoreContainer
        )
        /// Removed CodableStorable in CodableStoreContainer
        case removed(
            identifier: Storable.Identifier,
            container: CodableStoreContainer
        )
        /// Removed all CodableStorables in CodableStoreContainer
        case removedAll(
            container: CodableStoreContainer
        )
    }
    
}

// MARK: - Event+Equatable

extension CodableStore.Event: Equatable where Storable: Equatable, Storable.Identifier: Equatable {}

// MARK: - Event+Hashable

extension CodableStore.Event: Hashable where Storable: Hashable, Storable.Identifier: Hashable {}

// MARK: - Event+Container

public extension CodableStore.Event {
    
    /// The optional CodableStoreContainer
    var container: CodableStoreContainer? {
        switch self {
        case .saved(_, let container):
            return container
        case .removed(_, let container):
            return container
        case .removedAll(let container):
            return container
        }
    }
    
}
