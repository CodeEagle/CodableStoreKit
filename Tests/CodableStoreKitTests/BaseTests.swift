//
//  BaseTests.swift
//  TveeeKit
//
//  Created by Sven Tiigi on 09.04.18.
//  Copyright © 2018 opwoco GmbH. All rights reserved.
//

import XCTest
@testable import CodableStoreKit

struct User: CodableStoreable, Equatable {
    static var codableStoreIdentifier = \User.id
    let id: String
    let firstName: String
    let lastName: String
}

class BaseTests: XCTestCase {
    
    /// The timeout value while waiting
    /// that an expectation is fulfilled
    lazy var expectationTimeout: TimeInterval = 10.0
    
    /// Random String
    lazy var randomString: String = self.generateRandomString()
    
    /// Random Data
    lazy var randomData: Data = self.generateRandomData()
    
    /// Random Int
    lazy var randomInt: Int = self.generateRandomInt()
    
    /// Random Double
    lazy var randomDouble: Double = self.generateRandomDouble()
    
    /// System Image
    lazy var image: UIImage? = UIButton(type: .infoLight).image(for: .normal)
    
    /// Random User
    lazy var randomUser: User = self.generateRandomUser()
    
    /// SetUp
    override func setUp() {
        super.setUp()
        // Disable continueAfterFailure
        self.continueAfterFailure = false
    }
    
    /// Perform test with expectation
    ///
    /// - Parameters:
    ///   - name: The expectation name
    ///   - timeout: The optional custom timeout
    ///   - execution: The test execution
    ///   - completionHandler: The optional XCWaitCompletionHandler
    func performTest(name: String = "\(#function): Line \(#line)",
        timeout: TimeInterval? = nil,
        execution: (XCTestExpectation) -> Void,
        completionHandler: XCWaitCompletionHandler? = nil) {
        // Create expectation with function name
        let expectation = self.expectation(description: name)
        // Perform test execution with expectation
        execution(expectation)
        // Wait for expectation been fulfilled with custom or default timeout
        self.waitForExpectations(
            timeout: timeout.flatMap { $0 } ?? self.expectationTimeout,
            handler: completionHandler
        )
    }
    
    /// Generate a random String
    ///
    /// - Returns: A random string
    func generateRandomString() -> String {
        return UUID().uuidString
    }
    
    /// Generate a random Int
    ///
    /// - Returns: A random Int
    func generateRandomInt() -> Int {
        return Int(arc4random_uniform(100))
    }
    
    /// Generate a random Double
    ///
    /// - Returns: A random Double
    func generateRandomDouble() -> Double {
        return Double(self.generateRandomInt())
    }
    
    /// Generate a random Data object
    ///
    /// - Returns: Random Data object
    func generateRandomData() -> Data {
        return Data(self.generateRandomString().utf8)
    }
    
    func generateRandomUser() -> User {
        return .init(
            id: self.generateRandomString(),
            firstName: self.generateRandomString(),
            lastName: self.generateRandomString()
        )
    }
    
    func clearFilesystem() {
        let fileManager: FileManager = .default
        guard let directoryURL = try? fileManager.getSearchPathDirectoryURL() else {
            return
        }
        guard let paths = try? fileManager.contentsOfDirectory(atPath: directoryURL.path) else {
            return
        }
        paths.forEach {
            let url = directoryURL.appendingPathComponent($0)
            try? fileManager.removeItem(at: url)
            print(url.path)
        }
    }
    
    func fail(message: String = "") -> Never {
        XCTFail(message)
        fatalError(message)
    }
    
}

private extension FileManager {
    
    /// Retrieve the SearchPathDirectory URL
    ///
    /// - Returns: The SearchPathDirectory URL
    /// - Throws: If retrieving URL fails
    func getSearchPathDirectoryURL() throws -> URL {
        // Declare searchPathDirectory
        let searchPathDirectory: FileManager.SearchPathDirectory
        #if (tvOS)
        // tvOS only offers cachesDirectory
        searchPathDirectory = .cachesDirectory
        #else
        // Other Platforms allow the documentDirectory
        searchPathDirectory = .documentDirectory
        #endif
        // Return SearchPathDirectory URL
        return try self.url(
            for: searchPathDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }
    
}
