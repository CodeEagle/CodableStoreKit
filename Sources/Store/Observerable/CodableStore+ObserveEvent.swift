//
//  CodableStore+ObserveEvent.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStore.ObserveEvent

public extension CodableStore {
    
    /// The ObserveEvent
    enum ObserveEvent {
        /// Object has been saved in Container
        case saved(Object, CodableStoreContainer)
        /// Object has been deleted in Container
        case deleted(Object, CodableStoreContainer)
        
        /// The Object
        var object: Object {
            switch self {
            case .saved(let object, _):
                return object
            case .deleted(let object, _):
                return object
            }
        }
    }
    
}
