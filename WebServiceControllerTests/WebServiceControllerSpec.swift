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
            context("get(endpoint:parameters:completion:") {
                it("Should return an error through the completion closure if an invalid endpoint is provided") {
                    let endpoint = "Invalid URL Endpoint"
                    unitUnderTest.get(endpoint, completion: { (objects, _, error) in
                        expect((error as NSError?)?.code).to(equal(WebServiceError.Code.invalidURL.rawValue))
                    })
                }

                it("Should return nil if an invalid endpoint is provided") {
                    let endpoint = "Invalid URL Endpoint"
                    let result = unitUnderTest.get(endpoint, completion: {_,_,_ in })
                    expect(result).to(beNil())
                }

                it("Should return an error through the completion closure if the session provides an error") {
                    session.shouldReturnError = true

                    unitUnderTest.get(completion: { (objects, _, error) in
                        expect((error as NSError?)?.domain).to(equal("test.domain"))
                        expect((error as NSError?)?.code).to(equal(1234))
                    })
                }

                it("Should call dataToJSON on the deserialization object") {
                    let mockJSONHandler = MockJSONHandler()
                    unitUnderTest = WebServiceController(testingSession: session, jsonHandler: mockJSONHandler)

                    waitUntil() { done in
                        unitUnderTest.get(completion: { (object, _, error) in
                            expect(mockJSONHandler.dataToJSONCalled).to(beTrue())
                            done()
                        })
                    }
                }

                it("Should return an URLSessionDataTask if valid parameters are included") {
                    let result = unitUnderTest.get(completion: {_,_,_ in })
                    expect(result).to(beAKindOf(URLSessionDataTask.self))
                }
            }

            context("post(endpoint:parameters:json:completion:)") {
                it("Should return an error through the completion closure if an invalid endpoint is provided") {
                    let endpoint = "Invalid URL Endpoint"
                    unitUnderTest.post(endpoint, json: nil, completion: { (_, _, error) in
                        expect((error as NSError?)?.code).to(equal(WebServiceError.Code.invalidURL.rawValue))
                    })
                }

                it("Should return an error through the completion closure if the json object is nil") {
                    unitUnderTest.post(json: nil, completion: { (_, _, error) in
                        expect((error as NSError?)?.code).to(equal(WebServiceError.Code.noData.rawValue))
                    })
                }

                it("Should throw an exception if the json object cannot be converted to data") {
                    expect(unitUnderTest.post(json: NSObject(), completion: { (_,_,_) in })).to(raiseException())
                }

                it("Should return an error through the completion closure if the session provides an error") {
                    session.shouldReturnError = true

                    unitUnderTest.post(json: [:], completion: { (_,_, error) in
                        expect((error as NSError?)?.domain).to(equal("test.domain"))
                        expect((error as NSError?)?.code).to(equal(5678))
                    })
                }

                it("Should return an URLSessionDataTask if valid parameters are included") {
                    let result = unitUnderTest.post(json: [:], completion: { (_,_,_) in })
                    expect(result).to(beAKindOf(URLSessionUploadTask.self))
                }
            }

            context("put(endpoint:parameters:json:completion:)") {
                it("Should return an error through the completion closure if an invalid endpoint is provided") {
                    let endpoint = "Invalid URL Endpoint"
                    unitUnderTest.put(endpoint, json: nil, completion: { (_, _, error) in
                        expect((error as NSError?)?.code).to(equal(WebServiceError.Code.invalidURL.rawValue))
                    })
                }

                it("Should return an error through the completion closure if the json object is nil") {
                    unitUnderTest.put(json: nil, completion: { (_, _, error) in
                        expect((error as NSError?)?.code).to(equal(WebServiceError.Code.noData.rawValue))
                    })
                }

                it("Should throw an exception if the json object cannot be converted to data") {
                    expect(unitUnderTest.put(json: NSObject(), completion: { (_,_,_) in })).to(raiseException())
                }

                it("Should return an error through the completion closure if the session provides an error") {
                    session.shouldReturnError = true

                    unitUnderTest.put(json: [:], completion: { (_,_, error) in
                        expect((error as NSError?)?.domain).to(equal("test.domain"))
                        expect((error as NSError?)?.code).to(equal(5678))
                    })
                }

                it("Should return an URLSessionDataTask if valid parameters are included") {
                    let result = unitUnderTest.put(json: [:], completion: { (_,_,_) in })
                    expect(result).to(beAKindOf(URLSessionUploadTask.self))
                }
            }
        }
    }
}
