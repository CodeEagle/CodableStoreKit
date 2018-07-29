//
//  CodableStoreControllerable.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 06.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

// MARK: - CodableStoreControllerable

/// The CodableStoreControllerable Protocol
public protocol CodableStoreControllerable: class {
    
    /// The associatedtype BaseCodableStoreable Object
    associatedtype Object: BaseCodableStoreable
    
    /// The CodableStore
    var codableStore: CodableStore<Object> { get }
    
    /// The CodableStoreables
    var codableStoreables: [Object] { get set }
    
    /// The SubscriptionBag
    var subscriptionBag: ObserverableCodableStoreSubscriptionBag { get }
    
    /// CodableStoreables will update with observe event
    ///
    /// - Parameters:
    ///   - event: The CodableStoreControllerEvent
    ///   - codableStoreables: The current CodableStoreables before update
    func codableStoreablesWillUpdate(event: CodableStoreControllerEvent<Object>,
                                     codableStoreables: [Object])
    
    /// CodableStoreables did update with observe event
    ///
    /// - Parameters:
    ///   - event: The CodableStoreControllerEvent
    ///   - codableStoreables: The updated CodableStoreables
    func codableStoreablesDidUpdate(event: CodableStoreControllerEvent<Object>,
                                    codableStoreables: [Object])
    
}

// MARK: - CodableStoreControllerEvent

/// The CodableStoreControllerEvent
public enum CodableStoreControllerEvent<Object: BaseCodableStoreable> {
    /// Default Load Event
    case `default`
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
    
    /// Initializer with optional ObserveEvent
    ///
    /// - Parameter observeEvent: The ObserveEvent
    init(observeEvent: CodableStore<Object>.ObserveEvent?) {
        // Switch on ObserveEvent
        switch observeEvent {
        case .some(.saved(let object, let container)):
            self = .saved(
                object: object,
                container: container
            )
        case .some(.deleted(let object, let container)):
            self = .deleted(
                object: object,
                container: container
            )
        case .none:
            self = .default
        }
    }
    
}

// MARK: - CodableStoreControllerable Convenience Funtions

public extension CodableStoreControllerable {
    
    /// Reload CodableStoreables with CodableStoreControllerable-Lifecycle
    ///
    /// - Returns: The loaded CodableStoreables. Returns nil if loading failed
    @discardableResult
    public func reloadCodableStoreables() -> [Object]? {
        let objects: [Object]
        do {
            // Try to load Collection
            objects = try self.codableStore.getCollection()
        } catch {
            // Loading failed return error
            return nil
        }
        // Update CodableStoreables with Lifecycle
        self.updateCodableStoreables(
            event: .default,
            objects: objects
        )
        // Return loaded Objects
        return objects
    }
    
    /// Retrieve CodableStoreable at Index
    ///
    /// - Parameter index: The Index
    /// - Returns: CodableStoreable at Index if index is contained in indices
    public func codableStoreable(at index: Int) -> Object? {
        // Verfiy index is contained in indices
        guard self.codableStoreables.indices.contains(index) else {
            // Index out of bounds return nil
            return nil
        }
        // Return CodableStoreable at index
        return self.codableStoreables[index]
    }
    
}

// MARK: - Default Setup

extension CodableStoreControllerable {
    
    /// Setup CodeableStoreControllerable
    func setup() {
        // Verify SubscriptionBag is empty
        guard self.subscriptionBag.isEmpty else {
            // Return out of function
            return
        }
        // Reload CodableStoreables
        self.reloadCodableStoreables()
        // Observe Collection and disposed by SubscriptionBag
        self.codableStore.observeCollection { [weak self] event in
            // Retrieve Collection
            guard let weakSelf = self,
                let objects = try? weakSelf.codableStore.getCollection() else {
                    // Collection is unavailable
                    return
            }
            // Initialize CodableStoreControllerEvent with Observe Event
            let event = CodableStoreControllerEvent<Object>(observeEvent: event)
            // Update CodableStoreables
            self?.updateCodableStoreables(event: event, objects: objects)
        }.disposed(
            // Disposed by SubscriptionBag
            by: self.subscriptionBag
        )
    }
    
    /// Update CodableStoreables with CodableStoreControllerable Lifecycle
    ///
    /// - Parameters:
    ///   - event: The CodableStoreControllerEvent
    ///   - objects: The Objects
    private func updateCodableStoreables(event: CodableStoreControllerEvent<Object>, objects: [Object]) {
        // Will Update
        self.codableStoreablesWillUpdate(
            event: event,
            codableStoreables: self.codableStoreables
        )
        // Set Objects
        self.codableStoreables = objects
        // Did Update
        self.codableStoreablesDidUpdate(
            event: event,
            codableStoreables: objects
        )
    }
    
}
