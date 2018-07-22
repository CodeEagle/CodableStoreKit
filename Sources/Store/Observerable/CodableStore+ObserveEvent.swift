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
        /// Object has been saved in Container for Engine
        case saved(
            object: Object,
            container: CodableStoreContainer,
            engine: AnyCodableStoreEngine<Object>
        )
        /// Object has been deleted in Container for Engine
        case deleted(
            object: Object,
            container: CodableStoreContainer,
            engine: AnyCodableStoreEngine<Object>
        )
        
        /// The Object
        var object: Object {
            switch self {
            case .saved(let object, _, _):
                return object
            case .deleted(let object, _, _):
                return object
            }
        }
    }
    
}
