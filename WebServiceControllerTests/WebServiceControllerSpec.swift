//
//  WebServiceControllerSpec.swift
//  WebServiceController
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import WebServiceController

class WebServiceControllerSpec: QuickSpec {
    override func spec() {
        var session: MockSession!
        var unitUnderTest: WebServiceController!

        beforeEach {
            session = MockSession()
            unitUnderTest = WebServiceController(testingSession: session)
        }

        describe("WebServiceController") {
            context("queryParametersString(parametersDictionary:)") {
                it("Should return nil if no parameters are passed in.") {
                    expect(unitUnderTest.queryParametersString(nil)).to(beNil())
                }

                it("Should return nil if an empty array is passed in") {
                    expect(unitUnderTest.queryParametersString([:])).to(beNil())
                }

                it("Should return a string representation of a valid key value pair") {
                    expect(unitUnderTest.queryParametersString(["key1" : "value1"])).to(equal("key1=value1"))
                }

                it("Should combine valid key value pairs, separating with an &") {
                    let parameters = ["key1": "value1", "key2" : "value2"]
                    expect(unitUnderTest.queryParametersString(parameters)).to(equal("key1=value1&key2=value2"))
                }

                it("Should URL encode keys and values.") {
                    let parameters = ["key 1": "value 1"]
                    expect(unitUnderTest.queryParametersString(parameters)).to(equal("key%201=value%201"))
                }
            }

            context("urlWith(endpoint:parameters:)") {
                it("Should return a URL from the base URL if a no endpoint or parameters are passed in.") {
                    expect(unitUnderTest.urlWith().url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/"))
                }

                it("Should append the endpoint onto the base url") {
                    let endpoint = "endpoint/test"
                    let urlTuple = unitUnderTest.urlWith(endpoint: endpoint)
                    expect(urlTuple.url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/endpoint/test"))
                }

                it("Should append the endpoint onto the base url") {
                    let endpoint = "endpoint/test"
                    let urlTuple = unitUnderTest.urlWith(endpoint: endpoint)
                    expect(urlTuple.url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/endpoint/test"))
                }

                it("Should append the parameters string onto the base url") {
                    let parameters = ["key1" : "value1", "key2" : "value2"]
                    let urlTuple = unitUnderTest.urlWith(parameters: parameters)
                    expect(urlTuple.url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/?key1=value1&key2=value2"))
                }

                it("Should append the endpoint before the query parameters") {
                    let endpoint = "endpoint"
                    let parameters = ["key1" : "value1", "key2" : "value2"]
                    let urlTuple = unitUnderTest.urlWith(endpoint: endpoint, parameters: parameters)
                    expect(urlTuple.url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/endpoint?key1=value1&key2=value2"))
                }

                it("Should return an error if the URL cannot be formed from the endpoint") {
                    let endpoint = "Invalid URL Endpoint"
                    let urlTuple = unitUnderTest.urlWith(endpoint: endpoint)
                    expect(urlTuple.error?.code).to(equal(WebServiceError.Code.invalidURL.rawValue))
                }
            }

            context("get(endpoint:parameters:completion:") {
                it("Should return an error through the completion closure if an invalid endpoint is provided") {
                    let endpoint = "Invalid URL Endpoint"
                    unitUnderTest.get(endpoint, completion: { (objects, error) in
                        expect((error as NSError?)?.code).to(equal(WebServiceError.Code.invalidURL.rawValue))
                    })
                }

                it("Should return nil if an invalid endpoint is provided") {
                    let endpoint = "Invalid URL Endpoint"
                    let result = unitUnderTest.get(endpoint, completion: {_,_ in })
                    expect(result).to(beNil())
                }

                it("Should return an error through the completion closure if the session provides an error") {
                    session.shouldReturnError = true

                    unitUnderTest.get(completion: { (objects, error) in
                        expect((error as NSError?)?.domain).to(equal("test.domain"))
                        expect((error as NSError?)?.code).to(equal(1234))
                    })
                }

                it("Should call dataToJSON on the deserialization object") {
                    let mockDeserializer = MockDeserializer()
                    unitUnderTest = WebServiceController(testingSession: session, deserializer: mockDeserializer)

                    waitUntil() { done in
                        unitUnderTest.get(completion: { (object, error) in
                            expect(mockDeserializer.dataToJSONCalled).to(beTrue())
                            done()
                        })
                    }
                }

                it("Should return an URLSessionDataTask if valid parameters are included") {
                    let result = unitUnderTest.get(completion: {_,_ in })
                    expect(result).to(beAKindOf(URLSessionDataTask.self))
                }
            }
        }
    }
}
