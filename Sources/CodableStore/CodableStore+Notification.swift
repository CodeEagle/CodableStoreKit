//
//  CodableStore+Notification.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 22.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Notification

public extension CodableStore {
    
    /// The Notification
    struct Notification {
        
        // MARK: Properties
        
        /// The CodableStoreContainer where the Notification occured
        let container: CodableStoreContainer
        
        /// The Event
        let event: Event
        
        // MARK: Initializer
        
        /// Designated Initializer
        /// - Parameters:
        ///   - container: The CodableStoreContainer where the Notification occured
        ///   - event: The Event
        public init(
            container: CodableStoreContainer,
            event: Event
        ) {
            self.container = container
            self.event = event
        }
        
    }
    
}

// MARK: - Notification+Equatable

extension CodableStore.Notification: Equatable where Storable: Equatable, Storable.Identifier: Equatable {}

// MARK: - Notification+Hashable

extension CodableStore.Notification: Hashable where Storable: Hashable, Storable.Identifier: Hashable {}

// MARK: - Event

public extension CodableStore.Notification {
    
    /// The CodableStore Event
    enum Event {
        /// Saved CodableStorable
        case saved(storable: Storable)
        /// Removed CodableStorable
        case removed(identifier: Storable.Identifier)
        /// Removed all CodableStorables
        case removedAll
    }
    
}

// MARK: - Event+Equatable

extension CodableStore.Notification.Event: Equatable where Storable: Equatable, Storable.Identifier: Equatable {}

// MARK: - Event+Hashable

extension CodableStore.Notification.Event: Hashable where Storable: Hashable, Storable.Identifier: Hashable {}
