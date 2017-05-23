//
//  WebServiceControllerTests.swift
//  WebServiceControllerTests
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import WebServiceController

class WebServiceControllerSpec: QuickSpec {

    let unitUnderTest = WebServiceController()

    override func spec() {
        describe("WebServiceController") {
            context("queryParametersString(parametersDictionary:)") {
                it("Should return nil if no parameters are passed in.") {
                    expect(self.unitUnderTest.queryParametersString(nil)).to(beNil())
                }

                it("Should return nil if an empty array is passed in") {
                    expect(self.unitUnderTest.queryParametersString([:])).to(beNil())
                }

                it("Should return a string representation of a valid key value pair") {
                    expect(self.unitUnderTest.queryParametersString(["key1" : "value1"])).to(equal("key1=value1"))
                }

                it("Should combine valid key value pairs, separating with an &") {
                    let parameters = ["key1": "value1", "key2" : "value2"]
                    expect(self.unitUnderTest.queryParametersString(parameters)).to(equal("key1=value1&key2=value2"))
                }

                it("Should URL encode keys and values.") {
                    let parameters = ["key 1": "value 1"]
                    expect(self.unitUnderTest.queryParametersString(parameters)).to(equal("key%201=value%201"))
                }
            }

            context("urlWith(endpoint:parameters:)") {
                it("Should return a URL from the base URL if a no endpoint or parameters are passed in.") {
                    expect(self.unitUnderTest.urlWith().url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/"))
                }

                it("Should append the endpoint onto the base url") {
                    let endpoint = "endpoint/test"
                    let urlTuple = self.unitUnderTest.urlWith(endpoint: endpoint)
                    expect(urlTuple.url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/endpoint/test"))
                }

                it("Should append the endpoint onto the base url") {
                    let endpoint = "endpoint/test"
                    let urlTuple = self.unitUnderTest.urlWith(endpoint: endpoint)
                    expect(urlTuple.url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/endpoint/test"))
                }

                it("Should append the parameters string onto the base url") {
                    let parameters = ["key1" : "value1", "key2" : "value2"]
                    let urlTuple = self.unitUnderTest.urlWith(parameters: parameters)
                    expect(urlTuple.url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/?key1=value1&key2=value2"))
                }

                it("Should append the endpoint before the query parameters") {
                    let endpoint = "endpoint"
                    let parameters = ["key1" : "value1", "key2" : "value2"]
                    let urlTuple = self.unitUnderTest.urlWith(endpoint: endpoint, parameters: parameters)
                    expect(urlTuple.url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/endpoint?key1=value1&key2=value2"))
                }

                it("Should return an error if the URL cannot be formed from the endpoint") {
                    let endpoint = "Invalid URL Endpoint"
                    let urlTuple = self.unitUnderTest.urlWith(endpoint: endpoint)
                    expect(urlTuple.error?.code).to(equal(WebServiceError.Code.invalidURL.rawValue))
                }
            }
        }
    }
}
