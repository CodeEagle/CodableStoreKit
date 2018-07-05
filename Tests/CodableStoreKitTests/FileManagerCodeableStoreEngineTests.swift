//
//  FileManagerCodeableStoreEngineTests.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 03.07.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation
import XCTest
@testable import CodableStoreKit

class FileManagerCodeableStoreEngineTests: BaseTests {
    
    class FakeFileManager: FileManager {
        
        var createFileData: Data?
        
        override func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool {
            self.createFileData = data
            return true
        }
        
        override func url(for directory: FileManager.SearchPathDirectory,
                          in domain: FileManager.SearchPathDomainMask,
                          appropriateFor url: URL?,
                          create shouldCreate: Bool) throws -> URL {
            return URL(string: "FakeFileSystem")!
        }
        
    }
    
    lazy var fakeFileManager = FakeFileManager()
    
    lazy var storeEngine = FileManagerCodeableStoreEngine<User>(fileManager: self.fakeFileManager)
    
    
    func testSave() throws {
        let user = try self.storeEngine.save(self.randomUser)
        XCTAssertEqual(user, self.randomUser)
        guard let createFileUserData = self.fakeFileManager.createFileData else {
            self.fail(message: "User Data must be filled")
        }
        let createFileUser = try JSONDecoder().decode(User.self, from: createFileUserData)
        XCTAssertEqual(createFileUser, self.randomUser)
    }
    
    
}
