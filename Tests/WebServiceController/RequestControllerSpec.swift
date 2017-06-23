//
//  RequestControllerSpec.swift
//  WebServiceController
//
//  Created by Sean on 6/6/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import SKWebServiceController

class RequestControllerSpec: QuickSpec {

    override func spec() {
        describe("Requester") {
            var jsonHandler: MockJSONHandler!
            var session: MockSession!
            var urlConstructor: MockURLConstructor!
            var unitUnderTest: RequestController!

            beforeEach {
                jsonHandler = MockJSONHandler()
                session = MockSession()
                urlConstructor = MockURLConstructor()

                unitUnderTest = RequestController(jsonHandler: jsonHandler, session: session, urlConstructor: urlConstructor)
            }

            context("init(defaultRequestConfiguration:jsonHandler:session:urlConstructor:)") {
                it("Should set the JSON handler") {
                    expect(unitUnderTest.jsonHandler).to(be(jsonHandler))
                }

                it("Should set the session") {
                    expect(unitUnderTest.session).to(be(session))
                }

                it("Should set the URL constructor") {
                    expect(unitUnderTest.urlConstructor).to(be(urlConstructor))
                }
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

            context("performRequest(_:httpMethod:json:completion:)") {
                var request: URLRequest!

                beforeEach {
                    let url = URL(string: "https://example.url/")!
                    request = URLRequest(url: url)
                }

                it("Should not call json to data if nil json is provided") {
                    let _ = unitUnderTest.performRequest(request, httpMethod: .get, json: nil, completion: { (_, _, _) in })
                    expect(jsonHandler.jsonToDataCalled).to(beFalse())
                }

                it("Should call json to data if json is provided") {
                    let _ = unitUnderTest.performRequest(request, httpMethod: .get, json: [:], completion: { (_, _, _) in })
                    expect(jsonHandler.jsonToDataCalled).to(beTrue())
                }

                it("Should return an error through the completion if the json handler returns an error") {
                    jsonHandler.mockError = true
                    waitUntil { done in
                        let _ = unitUnderTest.performRequest(request, httpMethod: .get, json: [:], completion: { (_, _, outputError) in
                            expect(outputError).toNot(beNil())
                            done()
                        })
                    }
                }

                it("Should call dataTask for a delete request") {
                    let _ = unitUnderTest.performRequest(request, httpMethod: .delete, json: nil, completion: { (_, _, _) in })
                    expect(session.dataTaskWithRequestCalled).to(beTrue())
                }

                it("Should call dataTask for a get request") {
                    let _ = unitUnderTest.performRequest(request, httpMethod: .get, json: nil, completion: { (_, _, _) in })
                    expect(session.dataTaskWithRequestCalled).to(beTrue())
                }

                it("Should call uploadTask for a post request") {
                    let _ = unitUnderTest.performRequest(request, httpMethod: .post, json: nil, completion: { (_, _, _) in })
                    expect(session.uploadTaskCalled).to(beTrue())
                }

                it("Should call uploadTask for a put request") {
                    let _ = unitUnderTest.performRequest(request, httpMethod: .put, json: nil, completion: { (_, _, _) in })
                    expect(session.uploadTaskCalled).to(beTrue())
                }
            }

            context("performRequest(endpoint:parameters:json:httpMethod:completion:)") {
                it("Should add the parameters from the request configuration to the url constructor") {
                    let requestConfiguration = RequestConfiguration(queryParameters: ["key1" : "value1"])
                    let _ = unitUnderTest.performRequest(endpoint: nil, json: nil, httpMethod: .get, requestConfiguration: requestConfiguration, completion: { (_, _, _) in })
                    expect(urlConstructor.parameters).to(equal(["key1" : "value1"]))
                }

                it("Should call urlWith on the URL Constructor") {
                    let _ = unitUnderTest.performRequest(endpoint: nil, json: nil, httpMethod: .get, requestConfiguration: nil, completion: { (_, _, _) in })
                    expect(urlConstructor.urlWithEndpointCalled).to(beTrue())
                }

                it("Should return an error through the closure if the URL constructor returns an error") {
                    urlConstructor.shouldReturnError = true
                    waitUntil { done in
                        let _ = unitUnderTest.performRequest(endpoint: nil, json: nil, httpMethod: .get, requestConfiguration: nil, completion: { (_, _, outputError) in
                            expect(outputError).toNot(beNil())
                            done()
                        })
                    }
                }
            }
        }
    }
}
