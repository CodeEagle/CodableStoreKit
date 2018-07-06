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
public class CodableStore<Object: BaseCodableStoreable> {
    
    // MARK: Properties
    
    /// The Container
    public let container: CodableStoreContainer
    
    /// The Engine
    let engine: AnyCodableStoreEngine<Object>
    
    /// The Observer
    let observer: AnyObserverableCodableStore<Object>
    
    // MARK: Initializer

    /// Designated Initializer
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer. Default value `Default Container`
    ///   - engine: The Engine. Default value `.fileSystem`
    public init(container: CodableStoreContainer = .default,
                engine: Engine = .fileSystem) {
        self.container = container
        self.engine = engine.get(container: container)
        self.observer = ObserverStorage.sharedInstance.getObserver(objectType: Object.self)
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
        case custom(AnyCodableStoreEngine<Object>)
        
        /// Retrieve Engine as AnyCodableStoreEngine
        ///
        /// - Parameter container: The CodableStoreContainer
        /// - Returns: AnyCodableStoreEngine<Object>
        func get(container: CodableStoreContainer) -> AnyCodableStoreEngine<Object> {
            switch self {
            case .fileSystem:
                return .init(FileManagerCodeableStoreEngine(container: container))
            case .inMemory:
                return .init(InMemoryCodableStoreEngine(container: container))
            case .custom(let engine):
                return engine
            }
        }
    }

}

// MARK: - CodableStore ACL Properties

public extension CodableStore {
    
    /// WriteableCodableStore (Write-Only)
    public var writeableCodableStore: AnyWriteableCodableStore<Object> {
        return .init(self)
    }
    
    /// ReadableCodableStore (Read-Only)
    public var readableCodableStore: AnyReadableCodableStore<Object> {
        return .init(self)
    }
    
    /// ObservableCodableStore (Observe-Only)
    public var observableCodableStore: AnyObserverableCodableStore<Object> {
        return self.observer
    }
    
    /// MigrateableCodableStore (Migrate-Only)
    public var migrateableCodableStore: AnyMigrateableCodableStore<Object> {
        return .init(self)
    }
    
}
