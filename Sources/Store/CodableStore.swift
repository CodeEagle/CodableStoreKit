//
//  UserDefaultsCodableStore.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStore

/// The CodableStore
open class CodableStore<Object: BaseCodableStoreable> {
    
    // MARK: Properties
    
    /// The Container
    public let container: CodableStoreContainer
    
    /// The Engine
    let engine: AnyCodableStoreEngine<Object>
    
    /// The Observer
    let observer: AnyObserverableCodableStore<Object>
    
    // MARK: ACL Properties
    
    /// WriteableCodableStore (Write-Only)
    open var writeable: AnyWriteableCodableStore<Object> {
        return .init(self)
    }
    
    /// ReadableCodableStore (Read-Only)
    open var readable: AnyReadableCodableStore<Object> {
        return .init(self)
    }
    
    /// ObservableCodableStore (Observe-Only)
    open var observable: AnyObserverableCodableStore<Object> {
        return self.observer
    }
    
    /// CopyableCodableStore (Copy-Only)
    open var copyable: AnyCopyableCodableStore<Object> {
        return .init(self)
    }
    
    // MARK: Initializer

    /// Designated Initializer
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer. Default value `Default Container`
    ///   - engine: The Engine. Default value `.fileSystem`
    public init(container: CodableStoreContainer = .default,
                engine: Engine = .fileSystem) {
        self.container = container
        self.engine = engine.build(container: container)
        self.observer = ObserverStorage
            .sharedInstance
            .getObserver(objectType: Object.self)
    }
    
    /// Deinit
    deinit {
        /// Clear Observer usage for Object Type
        ObserverStorage
            .sharedInstance
            .clearObserveUsage(objectType: Object.self)
    }
    
}

// MARK: - CodableStore.Engine

public extension CodableStore {
    
    /// The Engine
    enum Engine {
        /// FileSystem
        case fileSystem
        /// InMemory
        case inMemory
        /// Supply custom CodableStoreEngine
        case custom((CodableStoreContainer) -> AnyCodableStoreEngine<Object>)
        
        /// Build Engine as AnyCodableStoreEngine
        ///
        /// - Parameter container: The CodableStoreContainer
        /// - Returns: AnyCodableStoreEngine<Object>
        func build(container: CodableStoreContainer) -> AnyCodableStoreEngine<Object> {
            switch self {
            case .fileSystem:
                return .init(FileManagerCodeableStoreEngine(container: container))
            case .inMemory:
                return .init(InMemoryCodableStoreEngine(container: container))
            case .custom(let customEngine):
                return customEngine(container)
            }
        }
    }

}

// MARK: - CodableStore.Result

public extension CodableStore {
    
    /// The CodableStore Result
    enum Result {
        /// Success with Object
        case success(Object)
        /// Failure with identifier and Error
        case failure(Object.ID, Error)
    }
    
}
