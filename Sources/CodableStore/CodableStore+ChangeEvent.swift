//
//  CodableStore+ChangeEvent.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 22.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - ChangeEvent

public extension CodableStore {
    
    /// The CodableStore ChangeEvent
    enum ChangeEvent {
        /// Saved CodableStorable in CodableStoreContainer
        case saved(
            storable: Storable,
            container: CodableStoreContainer
        )
        /// Deleted CodableStorable in CodableStoreContainer
        case deleted(
            identifier: Storable.Identifier,
            container: CodableStoreContainer
        )
        /// Deleted all CodableStorables in CodableStoreContainer
        case deletedAll(
            container: CodableStoreContainer
        )
    }
    
}

// MARK: - ChangeEvent+Equatable

extension CodableStore.ChangeEvent: Equatable where Storable: Equatable, Storable.Identifier: Equatable {}

// MARK: - ChangeEvent+Hashable

extension CodableStore.ChangeEvent: Hashable where Storable: Hashable, Storable.Identifier: Hashable {}

// MARK: - ChangeEvent+Container

public extension CodableStore.ChangeEvent {
    
    /// The CodableStoreContainer
    var container: CodableStoreContainer {
        switch self {
        case .saved(_, let container):
            return container
        case .deleted(_, let container):
            return container
        case .deletedAll(let container):
            return container
        }
    }
    
}
