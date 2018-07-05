 //
//  CodableStoreKitTests.swift
//  Sven Tiigi
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation
import XCTest
@testable import CodableStoreKit

class CodableStoreKitTests: BaseTests {
    
    static var allTests = [
        ("testExample", testEndToEndTestFileSystemEngine),
    ]
    
    override func setUp() {
        super.setUp()
        self.clearFilesystem()
    }
    
    override func tearDown() {
        super.tearDown()
        self.clearFilesystem()
    }
    
    func testEndToEndTestFileSystemEngine() throws {
        try self.endToEndTest(codableStoreEngine: .fileSystem)
    }
    
    func testEndToEndTestInMemory() throws {
        try self.endToEndTest(codableStoreEngine: .inMemory)
    }
    
    func endToEndTest(codableStoreEngine: CodableStore<User>.Engine) throws {
        let codableStore = CodableStore<User>(engine: codableStoreEngine)
        let savedUser = try codableStore.save(self.randomUser)
        XCTAssertEqual(savedUser, self.randomUser)
        let retrievedUser = try codableStore.get(identifier: savedUser.id)
        XCTAssertEqual(retrievedUser, self.randomUser)
        let retrievedUsers = try codableStore.getCollection()
        XCTAssertEqual(retrievedUsers.count, 1)
        XCTAssertEqual(retrievedUsers.first, self.randomUser)
        let deletedUser = try codableStore.delete(self.randomUser)
        XCTAssertEqual(deletedUser, self.randomUser)
        let retrievedUsers2 = try codableStore.getCollection()
        XCTAssert(retrievedUsers2.isEmpty)
        do {
            _ = try codableStore.get(identifier: self.randomUser.id)
            XCTFail("User mustn't be available")
        } catch {}
    }
    
    
}
