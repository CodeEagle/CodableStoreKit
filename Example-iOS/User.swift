//
//  User.swift
//  Example-iOS
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import CodableStoreKit
import Foundation

struct User: Codable, Equatable {
    let id: String
    let firstName: String
    let lastName: String
}

extension User: CodableStoreable {
    
    static var codableStoreIdentifier: KeyPath<User, String> {
        return \User.id
    }
    
    
 
}

extension User {
    
    static var codableStoreCollectionName: String {
        return String(describing: type(of: self))
    }
    
}
