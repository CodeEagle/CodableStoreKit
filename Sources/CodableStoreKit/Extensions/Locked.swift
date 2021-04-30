//
//  Locked.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 19.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

import Foundation

/// ThreadSafe Locked Value
public final class Locked<Value> {
    
    /// The Lock fastest option (https://gist.github.com/steipete/36350a8a60693d440954b95ea6cbbafc)
    private var lock = os_unfair_lock()
    
    /// The internal Value
    private var internalValue: Value
    
    /// The Value
    public var value: Value {
        get {
            os_unfair_lock_lock(&self.lock)
            defer {
                os_unfair_lock_unlock(&self.lock)
            }
            return self.internalValue
        }
        set {
            os_unfair_lock_lock(&self.lock)
            defer {
                os_unfair_lock_unlock(&self.lock)
            }
            self.internalValue = newValue
        }
    }
    
    /// Default initializer with Value
    ///
    /// - Parameter value: The Value
    public init(_ value: Value) {
        self.internalValue = value
    }
    
    /// Mutate value
    ///
    /// - Parameter changes: The changes closure
    public func mutate(_ changes: (inout Value) -> Void) {
        os_unfair_lock_lock(&self.lock)
        defer {
            os_unfair_lock_unlock(&self.lock)
        }
        changes(&self.internalValue)
    }
    
}
