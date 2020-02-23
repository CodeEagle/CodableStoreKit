//
//  CodableStore+Observe.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 07.12.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - Observe

public extension CodableStore {
    
    /// Observe CodableStore ChangeEvent
    /// - Parameters:
    ///   - object: The Object to observe on
    ///   - observer: The Observer
    func observe<Object: AnyObject>(
        on object: Object,
        _ observer: @escaping (ChangeEvent) -> Void
    ) {
        // Observe on NotificationCenter
        self.notificationCenter.observe(on: object, observer)
    }
    
}
