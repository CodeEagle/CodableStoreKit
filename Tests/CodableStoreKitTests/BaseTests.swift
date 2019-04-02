//
//  BaseTests.swift
//  CodableStoreKit
//
//  Created by Sven Tiigi on 23.03.19.
//  Copyright © 2019 CodableStoreKit. All rights reserved.
//

@testable import CodableStoreKit
import XCTest

/// The BaseTests
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
            identifier: UUID().uuidString,
            firstName: UUID().uuidString,
            lastName: UUID().uuidString
        )
    }
    
}
