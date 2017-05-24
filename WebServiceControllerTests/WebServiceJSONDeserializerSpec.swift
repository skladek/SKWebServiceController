//
//  WebServiceJSONDeserializerSpec.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import WebServiceController

class WebServiceJSONDeserializerSpec: QuickSpec {

    override func spec() {
        describe("WebServiceError") {
            var unitUnderTest: JSONHandler!

            beforeEach {
                unitUnderTest = JSONHandler()
            }

            context("dataToJSON(_:completion:") {
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
        }
    }
}
