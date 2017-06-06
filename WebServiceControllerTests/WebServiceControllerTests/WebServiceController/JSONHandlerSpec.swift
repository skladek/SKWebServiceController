//
//  JSONHandler.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import WebServiceController

class JSONHandlerSpec: QuickSpec {

    override func spec() {
        describe("WebServiceError") {
            var unitUnderTest: JSONHandler!

            beforeEach {
                unitUnderTest = JSONHandler()
            }

            context("dataToJSON(_:") {
                it("Should return an error if data is nil") {
                    let result = unitUnderTest.dataToJSON(nil)
                    expect((result.error as NSError?)?.code).to(equal(WebServiceError.Code.noData.rawValue))
                }

                it("Should deserialize valid data and return the object through the completion closure") {
                    let dictionary = ["key1" : "value1", "key2" : "value2"]
                    var jsonData: Data?

                    do {
                        jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
                    } catch {
                        print(error)
                    }

                    let result = unitUnderTest.dataToJSON(jsonData)
                    expect(result.object as? [String : String]).to(equal(dictionary))
                }

                it("Should return an error if the data cannot be deserialized") {
                    let result = unitUnderTest.dataToJSON(Data())
                    expect(result.error).toNot(beNil())
                }
            }

            context("jsonToData(_:)") {
                it("Should return an error if the json object is nil") {
                    let result = unitUnderTest.jsonToData(nil)
                    expect((result.error as NSError?)?.code).to(equal(WebServiceError.Code.noData.rawValue))
                }

                it("Should return data if a valid json object is passed in") {
                    let dictionary = ["key1" : "value1", "key2" : "value2"]
                    let result = unitUnderTest.jsonToData(dictionary)

                    expect(result.object).toNot(beNil())
                }

                it("Should return an error if the object is not a valid JSON object") {
                    let result = unitUnderTest.jsonToData(NSObject())
                    expect((result.error as NSError?)?.code).to(equal(WebServiceError.Code.invalidData.rawValue))
                }

                it("Should return an error if the object cannot be serialized") {
                    unitUnderTest = JSONHandler(JSONSerializationType: MockJSONSerialization.self)
                    let dictionary = ["key1" : "value1", "key2" : "value2"]
                    let result = unitUnderTest.jsonToData(dictionary)

                    expect((result.error as NSError?)?.code).to(equal(2345))
                }
            }
        }
    }
}
