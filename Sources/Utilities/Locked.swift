//
//  Locked.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 SubjectKit. All rights reserved.
//

import Foundation

/// A LockedValue for Thread-Safe Access
class Locked<Value> {
    
    /// The Lock fastest option (https://gist.github.com/steipete/36350a8a60693d440954b95ea6cbbafc)
    private var lock = os_unfair_lock()
    
    /// The internal stored Value
    private var _value: Value
    
    /// The Value
    var value: Value {
        get {
            os_unfair_lock_lock(&self.lock)
            defer {
                os_unfair_lock_unlock(&self.lock)
            }
            return self._value
        }
        set {
            os_unfair_lock_lock(&self.lock)
            defer {
                os_unfair_lock_unlock(&self.lock)
            }
            self._value = newValue
        }
    }
    
    /// Default initializer with Value
    ///
    /// - Parameter value: The Value
    init(_ value: Value) {
        self._value = value
    }
    
    /// Mutate value
    ///
    /// - Parameter changes: The changes closure
    func mutate(_ changes: (inout Value) -> Void) {
        os_unfair_lock_lock(&self.lock)
        defer {
            os_unfair_lock_unlock(&self.lock)
        }
        changes(&self._value)
    }
    
}
