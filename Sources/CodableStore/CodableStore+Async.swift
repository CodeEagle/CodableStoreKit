//
//  CodableStore+Async.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 23.02.20.
//  Copyright © 2020 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Async

public extension CodableStore {
    
    /// Make `AsyncCodableStore`
    /// - Parameter queue: The DispatchQueue. Default value `.global()`
    func asyncCodableStore(
        queue: DispatchQueue = .global()
    ) -> AsyncCodableStore<Storable> {
        .init(
            queue: queue,
            codableStore: self
        )
    }
    
}
