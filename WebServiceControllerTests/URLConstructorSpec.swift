//
//  URLConstructorSpec.swift
//  WebServiceController
//
//  Created by Sean on 5/24/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import WebServiceController

class URLConstructorSpec: QuickSpec {
    override func spec() {
        describe("WebServiceController") {
            context("queryParametersString(parametersDictionary:)") {
                it("Should return nil if no parameters are passed in.") {
                    expect(URLConstructor.queryParametersString(nil)).to(beNil())
                }

                it("Should return nil if an empty array is passed in") {
                    expect(URLConstructor.queryParametersString([:])).to(beNil())
                }

                it("Should return a string representation of a valid key value pair") {
                    expect(URLConstructor.queryParametersString(["key1" : "value1"])).to(equal("key1=value1"))
                }

                it("Should combine valid key value pairs, separating with an &") {
                    let parameters = ["key1": "value1", "key2" : "value2"]
                    expect(URLConstructor.queryParametersString(parameters)).to(equal("key1=value1&key2=value2"))
                }

                it("Should URL encode keys and values.") {
                    let parameters = ["key 1": "value 1"]
                    expect(URLConstructor.queryParametersString(parameters)).to(equal("key%201=value%201"))
                }
            }

            context("urlWith(endpoint:parameters:)") {
                it("Should return a URL from the base URL if a no endpoint or parameters are passed in.") {
                    expect(URLConstructor.urlWith().url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/"))
                }

                it("Should append the endpoint onto the base url") {
                    let endpoint = "endpoint/test"
                    let urlTuple = URLConstructor.urlWith(endpoint: endpoint)
                    expect(urlTuple.url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/endpoint/test"))
                }

                it("Should append the endpoint onto the base url") {
                    let endpoint = "endpoint/test"
                    let urlTuple = URLConstructor.urlWith(endpoint: endpoint)
                    expect(urlTuple.url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/endpoint/test"))
                }

                it("Should append the parameters string onto the base url") {
                    let parameters = ["key1" : "value1", "key2" : "value2"]
                    let urlTuple = URLConstructor.urlWith(parameters: parameters)
                    expect(urlTuple.url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/?key1=value1&key2=value2"))
                }

                it("Should append the endpoint before the query parameters") {
                    let endpoint = "endpoint"
                    let parameters = ["key1" : "value1", "key2" : "value2"]
                    let urlTuple = URLConstructor.urlWith(endpoint: endpoint, parameters: parameters)
                    expect(urlTuple.url?.absoluteString).to(equal("https://jsonplaceholder.typicode.com/endpoint?key1=value1&key2=value2"))
                }

                it("Should return an error if the URL cannot be formed from the endpoint") {
                    let endpoint = "Invalid URL Endpoint"
                    let urlTuple = URLConstructor.urlWith(endpoint: endpoint)
                    expect(urlTuple.error?.code).to(equal(WebServiceError.Code.invalidURL.rawValue))
                }
            }
        }
    }
}
