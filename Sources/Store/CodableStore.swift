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
    public var container: CodableStoreContainer {
        return self.engine.container
    }
    
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
    ///   - engine: The CodableStoreEngine
    public init<CE: CodableStoreEngine>(engine: CE) where CE.Object == Object {
        self.engine = AnyCodableStoreEngine<Object>(engine)
        self.observer = ObserverStorage
            .sharedInstance
            .getObserver(objectType: Object.self)
    }

    /// Convenience Initializer with Container and Engine
    ///
    /// - Parameters:
    ///   - container: The CodableStoreContainer. Default value `Default Container`
    ///   - engine: The Engine. Default value `.fileSystem`
    public convenience init(container: CodableStoreContainer = .default,
                            engine: Engine = .fileSystem) {
        // Switch on Engine
        switch engine {
        case .fileSystem:
            // Init with FileManagerCodableStoreEngine
            self.init(
                engine: FileManagerCodeableStoreEngine(
                    container: container
                )
            )
        case .inMemory:
            // Init with InMemoryCodableStoreEngine
            self.init(
                engine: InMemoryCodableStoreEngine(
                    container: container
                )
            )
        }
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
