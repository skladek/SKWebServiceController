//
//  JSONHandlerTests.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import SKWebServiceController

class JSONHandlerTests: XCTestCase {
    var unitUnderTest: JSONHandler!

    override func setUp() {
        unitUnderTest = JSONHandler()
    }

    // MARK: dataToJSON(_:) -> ConvertedJSON

    func testReturnErrorForNilData() {
        let result = unitUnderTest.dataToJSON(nil).error as NSError?
        XCTAssertEqual(result!.code, WebServiceError.Code.noData.rawValue)
    }

    func testDeserializingAndReturningThroughTheClosure() {
        let dictionary = ["key1" : "value1", "key2" : "value2"]
        var jsonData: Data?

        do {
            jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        } catch {
            print(error)
        }

        let result = unitUnderTest.dataToJSON(jsonData).object as? [String : String]
        XCTAssertEqual(result!, dictionary)
    }

    func testDeserializationError() {
        let result = unitUnderTest.dataToJSON(Data()).error as NSError?
        XCTAssertNotNil(result)
    }

    // MARK: jsonToData(_:) -> ConvertedJSON

    func testReturnErrorIfJSONIsNil() {
        let result = unitUnderTest.jsonToData(nil).error as NSError?
        XCTAssertEqual(result!.code, WebServiceError.Code.noData.rawValue)
    }

    func testReturnDataWithValidJSON() {
        let dictionary = ["key1" : "value1", "key2" : "value2"]
        let result = unitUnderTest.jsonToData(dictionary).object
        XCTAssertNotNil(result)
    }

    func testReturnErrorIfJSONIsInvalid() {
        let result = unitUnderTest.jsonToData(NSObject()).error as NSError?
        XCTAssertEqual(result!.code, WebServiceError.Code.invalidData.rawValue)
    }

    func testReturnErrorIfObjectCannotBeSerialized() {
        unitUnderTest = JSONHandler(JSONSerializationType: MockJSONSerialization.self)
        let dictionary = ["key1" : "value1", "key2" : "value2"]
        let result = unitUnderTest.jsonToData(dictionary).error as NSError?
        XCTAssertEqual(result!.code, 2345)
    }
}
