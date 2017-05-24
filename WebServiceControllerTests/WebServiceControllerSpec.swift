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
