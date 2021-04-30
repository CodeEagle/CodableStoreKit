//
//  CodableStore+AccessControl.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 19.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

// MARK: - CodableStore+AccessControl

public extension CodableStore {
    
    /// The AccessControl
    struct AccessControl {
        
        /// The CodableStore
        let codableStore: CodableStore<Storable>
        
        /// The SaveableCodableStore
        public var saveable: SaveableCodableStore<Storable> {
            return .init(self.codableStore)
        }
        
        /// The DeletableCodableStore
        public var deletable: DeletableCodableStore<Storable> {
            return .init(self.codableStore)
        }
        
        /// The WritableCodableStore
        public var writable: WritableCodableStore<Storable> {
            return .init(self.codableStore)
        }
        
        /// The ReadableCodableStore
        public var readable: ReadableCodableStore<Storable> {
            return .init(self.codableStore)
        }
        
        /// The ObservableCodableStore
        public var observable: ObservableCodableStore<Storable> {
            return .init(self.codableStore)
        }
        
    }
    
}

// MARK: - CodableStore+AccessControl Property

public extension CodableStore {
    
    /// The AccessControl
    var accessControl: AccessControl {
        return .init(codableStore: self)
    }
    
}
