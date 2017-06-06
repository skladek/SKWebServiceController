//
//  RequesterSpec.swift
//  WebServiceController
//
//  Created by Sean on 6/6/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import WebServiceController

class RequesterSpec: QuickSpec {

    override func spec() {
        describe("Requester") {
            var defaultParameters: [String : String]!
            var jsonHandler: MockJSONHandler!
            var session: MockSession!
            var urlConstructor: URLConstructor!
            var unitUnderTest: Requester!

            beforeEach {
                defaultParameters = ["key1" : "value1", "key2" : "value2"]
                jsonHandler = MockJSONHandler()
                session = MockSession()
                urlConstructor = URLConstructor(baseURL: "https://example.url/")
                unitUnderTest = Requester(defaultParameters: defaultParameters, jsonHandler: jsonHandler, session: session, urlConstructor: urlConstructor)
            }

            context("dataTask(request: URLRequest, completion: @escaping RequestCompletion)") {
                it("Should call dataTask on the session") {
                    let url = URL(string: "http://example.url")!
                    let request = URLRequest(url: url)
                    let _ = unitUnderTest.dataTask(request: request, completion: { (_, _, _) in })

                    expect(session.dataTaskWithRequestCalled).to(beTrue())
                }

                it("Should return the data task that is returned by the session") {
                    let inputDataTask = MockURLSesionDataTask()
                    session.dataTask = inputDataTask
                    let url = URL(string: "http://example.url")!
                    let request = URLRequest(url: url)
                    let outputDataTask = unitUnderTest.dataTask(request: request, completion: { (_, _, _) in })

                    expect(outputDataTask).to(be(inputDataTask))
                }
            }

            context("imageCompletion(data:response:error:completion:)") {
                it("Should execute the completion on the main thread") {
                    waitUntil { done in
                        DispatchQueue.global(qos: .background).async {
                            unitUnderTest.imageCompletion(data: nil, response: nil, error: nil, completion: { (_, _, _) in
                                expect(Thread.isMainThread).to(beTrue())
                                done()
                            })
                        }
                    }
                }

                it("Should return an error in the completion if an error is passed in") {
                    let inputError = NSError(domain: "com.test.domain", code: 999, userInfo: nil)
                    waitUntil { done in
                        unitUnderTest.imageCompletion(data: nil, response: nil, error: inputError, completion: { (_, _, outputError) in
                            expect(outputError).to(be(inputError))
                            done()
                        })
                    }
                }

                it("Should return a nil image parameter if no data is passed in") {
                    waitUntil { done in
                        unitUnderTest.imageCompletion(data: nil, response: nil, error: nil, completion: { (outputImage, _, _) in
                            expect(outputImage).to(beNil())
                            done()
                        })
                    }
                }

                it("Should return an image if data is passed in") {
                    let bundle = Bundle(for: type(of: self))
                    let image = UIImage(named: "testimage", in: bundle, compatibleWith: nil)
                    let data = UIImagePNGRepresentation(image!)

                    waitUntil { done in
                        unitUnderTest.imageCompletion(data: data, response: nil, error: nil, completion: { (outputImage, _, _) in
                            expect(outputImage).toNot(beNil())
                            done()
                        })
                    }
                }
            }

            context("jsonCompletion(data:response:error:completion:)") {
                it("Should execute the completion on the main thread") {
                    waitUntil { done in
                        DispatchQueue.global(qos: .background).async {
                            unitUnderTest.jsonCompletion(data: nil, response: nil, error: nil, completion: { (_, _, _) in
                                expect(Thread.isMainThread).to(beTrue())
                                done()
                            })
                        }
                    }
                }

                it("Should return an error in the completion if an error is passed in") {
                    let inputError = NSError(domain: "com.test.domain", code: 999, userInfo: nil)
                    waitUntil { done in
                        unitUnderTest.jsonCompletion(data: nil, response: nil, error: inputError, completion: { (_, _, outputError) in
                            expect(outputError).to(be(inputError))
                            done()
                        })
                    }
                }

                it("Should call data to json on the json handler if no error is passed in") {
                    waitUntil { done in
                        unitUnderTest.jsonCompletion(data: nil, response: nil, error: nil, completion: { (_, _, _) in
                            expect(jsonHandler.dataToJSONCalled).to(beTrue())
                            done()
                        })
                    }
                }
            }
        }
    }
}