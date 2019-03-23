//
//  CodableStorableTests.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 23.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

@testable import CodableStoreKit
import XCTest

class CodableStorableTests: BaseTests {
    
    static var allTests = [
        ("testCollectionName", testCollectionName),
    ]
    
    func testCollectionName() {
        XCTAssertEqual(String(describing: type(of: User.self)), User.codableStoreCollectionName.stringRepresentation)
    }
    
}
