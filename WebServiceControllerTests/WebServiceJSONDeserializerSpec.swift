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
            var unitUnderTest: WebServiceJSONDeserializer!

            beforeEach {
                unitUnderTest = WebServiceJSONDeserializer()
            }

            context("dataToJSON(_:completion:") {
                it("Should return an error if data is nil") {
                    waitUntil() { done in
                        unitUnderTest.dataToJSON(nil, completion: { (objects, error) in
                            expect((error as NSError?)?.code).to(equal(WebServiceError.Code.noData.rawValue))
                            done()
                        })
                    }
                }

                it("Should deserialize valid data and return the object through the completion closure") {
                    let dictionary = ["key1" : "value1", "key2" : "value2"]
                    var jsonData: Data?

                    do {
                        jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
                    } catch {
                        print(error)
                    }

                    waitUntil() { done in
                        unitUnderTest.dataToJSON(jsonData, completion: { (objects, error) in
                            expect(objects as? [String : String]).to(equal(dictionary))
                            done()
                        })
                    }
                }

                it("Should return an error if the data cannot be deserialized") {
                    waitUntil() { done in
                        unitUnderTest.dataToJSON(Data(), completion: { (objects, error) in
                            expect(error).toNot(beNil())
                            done()
                        })
                    }
                }
            }
        }
    }
}
