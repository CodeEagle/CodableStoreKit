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
            container: CodableStoreContainer
        )
        /// Object has been deleted in Container for Engine
        case deleted(
            object: Object,
            container: CodableStoreContainer
        )
        
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

// MARK: - CustomStringConvertible

extension CodableStore.ObserveEvent: CustomStringConvertible {
    
    /// A textual representation of this instance
    public var description: String {
        let objectName: (Object) -> String = {
            return String(describing: Mirror(reflecting: $0).subjectType)
        }
        let eventName: String
        let containerName: String
        switch self {
        case .saved(_, let container):
            eventName = "Saved"
            containerName = container.name
        case .deleted(_, let container):
            eventName = "Deleted"
            containerName = container.name
        }
        return "[\(eventName)] \(objectName(self.object)) in Container: \(containerName) => \(self.object)"
    }
    
}
