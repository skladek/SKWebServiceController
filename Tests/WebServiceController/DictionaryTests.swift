//
//  DictionaryTests.swift
//  SKWebServiceController
//
//  Created by Sean on 6/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import SKWebServiceController

class DictionaryTests: XCTestCase {
    var unitUnderTest: Dictionary<AnyHashable, Any>!

    override func setUp() {
        unitUnderTest = [:]
    }

    // MARK: stringValue(_:) -> String

    func testInputAsTrue() {
        let result = unitUnderTest.stringValue(true)
        XCTAssertTrue(result == "1")
    }

    func testInputAsFalse() {
        let result = unitUnderTest.stringValue(false)
        XCTAssertTrue(result == "0")
    }

    func testInputAsFloat() {
        let result = unitUnderTest.stringValue(1.234)
        XCTAssertTrue(result == "1.234")
    }

    func testInputAsInt() {
        let result = unitUnderTest.stringValue(1234)
        XCTAssertTrue(result == "1234")
    }

    func testInputAsString() {
        let result = unitUnderTest.stringValue("Test String")
        XCTAssertTrue(result == "Test String")
    }
}
