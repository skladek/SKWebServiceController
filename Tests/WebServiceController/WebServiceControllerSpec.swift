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
        var requester: MockRequester!
        var unitUnderTest: WebServiceController!

        beforeEach {
            requester = MockRequester()
            unitUnderTest = WebServiceController(testRequester: requester)
        }

        describe("WebServiceController") {
            context("init(baseURL:defaultParameters:)") {
                var baseURL: String!
                var defaultParameters: [String : String]!

                beforeEach {
                    baseURL = "https://testbaseurl.com"
                    defaultParameters = ["key1" : "value1", "key2" : "value2"]
                    unitUnderTest = WebServiceController(baseURL: baseURL, defaultParameters: defaultParameters)
                }

                it("Should pass the base URL to the URLConstructor") {
                    expect(((unitUnderTest.requester as! Requester).urlConstructor as! URLConstructor).baseURL).to(equal(baseURL))
                }

                it("Should pass the default parameters to the requester") {
                    expect((unitUnderTest.requester as! Requester).defaultParameters).to(equal(defaultParameters))
                }
            }

            context("delete(endpoint:completion:)") {
                it("Should call performRequestWithEndpoint on the requester") {
                    unitUnderTest.delete(completion: { (_, _, _) in
                        expect(requester.performRequestWithEndpointCalled).to(beTrue())
                    })
                }

                it("Should call the JSON handler in the completion") {
                    unitUnderTest.delete(completion: { (_, _, _) in
                        expect(requester.jsonCompletionCalled).to(beTrue())
                    })
                }

                it("Should return the data task returned by the requester") {
                    let inputTask = URLSessionDataTask()
                    requester.dataTask = inputTask
                    let returnedTask = unitUnderTest.delete(completion: { (_, _, _) in })
                    expect(returnedTask).to(be(inputTask))
                }

                it("Should return nil if no task is returned by the requester") {
                    let returnedTask = unitUnderTest.delete(completion: { (_, _, _) in })
                    expect(returnedTask).to(beNil())
                }
            }

            context("get(endpoint:parameters:completion:") {
                it("Should call performRequestWithEndpoint on the requester") {
                    unitUnderTest.get(completion: { (_, _, _) in
                        expect(requester.performRequestWithEndpointCalled).to(beTrue())
                    })
                }

                it("Should call the JSON handler in the completion") {
                    unitUnderTest.get(completion: { (_, _, _) in
                        expect(requester.jsonCompletionCalled).to(beTrue())
                    })
                }

                it("Should return the data task returned by the requester") {
                    let inputTask = URLSessionDataTask()
                    requester.dataTask = inputTask
                    let returnedTask = unitUnderTest.get(completion: { (_, _, _) in })
                    expect(returnedTask).to(be(inputTask))
                }

                it("Should return nil if no task is returned by the requester") {
                    let returnedTask = unitUnderTest.get(completion: { (_, _, _) in })
                    expect(returnedTask).to(beNil())
                }
            }

            context("getImage(url:completion:)") {
                it("Should call performRequestWithEndpoint on the requester") {
                    unitUnderTest.post(json: nil, completion: { (_, _, _) in
                        expect(requester.performRequestWithEndpointCalled).to(beTrue())
                    })
                }

                it("Should call the JSON handler in the completion") {
                    unitUnderTest.post(json: nil, completion: { (_, _, _) in
                        expect(requester.jsonCompletionCalled).to(beTrue())
                    })
                }

                it("Should return the data task returned by the requester") {
                    let inputTask = URLSessionDataTask()
                    requester.dataTask = inputTask
                    let returnedTask = unitUnderTest.post(json: nil, completion: { (_, _, _) in })
                    expect(returnedTask).to(be(inputTask))
                }

                it("Should return nil if no task is returned by the requester") {
                    let returnedTask = unitUnderTest.post(json: nil, completion: { (_, _, _) in })
                    expect(returnedTask).to(beNil())
                }
            }

            context("post(endpoint:parameters:json:completion:)") {
                var url: URL!

                beforeEach {
                    url = URL(string: "http://example.url")!
                }

                it("Should call performRequest on the requester") {
                    unitUnderTest.getImage(url, completion: { (_, _, _) in
                        expect(requester.performRequestCalled).to(beTrue())
                    })
                }

                it("Should call the image handler in the completion") {
                    unitUnderTest.getImage(url, completion: { (_, _, _) in
                        expect(requester.imageCompletionCalled).to(beTrue())
                    })
                }

                it("Should return the data task returned by the requester") {
                    let inputTask = URLSessionDataTask()
                    requester.dataTask = inputTask
                    let returnedTask = unitUnderTest.getImage(url, completion: { (_, _, _) in })
                    expect(returnedTask).to(be(inputTask))
                }

                it("Should return nil if no task is returned by the requester") {
                    let returnedTask = unitUnderTest.getImage(url, completion: { (_, _, _) in })
                    expect(returnedTask).to(beNil())
                }
            }

            context("put(endpoint:parameters:json:completion:)") {
                it("Should call performRequestWithEndpoint on the requester") {
                    unitUnderTest.put(json: nil, completion: { (_, _, _) in
                        expect(requester.performRequestWithEndpointCalled).to(beTrue())
                    })
                }

                it("Should call the JSON handler in the completion") {
                    unitUnderTest.put(json: nil, completion: { (_, _, _) in
                        expect(requester.jsonCompletionCalled).to(beTrue())
                    })
                }

                it("Should return the data task returned by the requester") {
                    let inputTask = URLSessionDataTask()
                    requester.dataTask = inputTask
                    let returnedTask = unitUnderTest.put(json: nil, completion: { (_, _, _) in })
                    expect(returnedTask).to(be(inputTask))
                }

                it("Should return nil if no task is returned by the requester") {
                    let returnedTask = unitUnderTest.put(json: nil, completion: { (_, _, _) in })
                    expect(returnedTask).to(beNil())
                }
            }
        }
    }
}
