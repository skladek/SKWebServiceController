import Foundation
import Nimble
import Quick

@testable import SKWebServiceController

class RequestControllerSpec: QuickSpec {

    override func spec() {
        describe("Requester") {
            var jsonHandler: MockJSONHandler!
            var localFileController: MockLocalFileRequestController!
            var session: MockSession!
            var urlConstructor: MockURLConstructor!
            var unitUnderTest: RequestController!

            beforeEach {
                jsonHandler = MockJSONHandler()
                localFileController = MockLocalFileRequestController()
                session = MockSession()
                urlConstructor = MockURLConstructor()

                unitUnderTest = RequestController(jsonHandler: jsonHandler, localFileController: localFileController, session: session, urlConstructor: urlConstructor)
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

            context("dataCompletion(data:response:error:completion:)") {
                it("Should execute the completion on the main thread") {
                    waitUntil { done in
                        DispatchQueue.global(qos: .background).async {
                            unitUnderTest.dataCompletion(data: nil, response: nil, error: nil, completion: { (_, _, _) in
                                expect(Thread.isMainThread).to(beTrue())
                                done()
                            })
                        }
                    }
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

            context("loadToken(keychain:)") {
                var keychain: MockKeychain!

                beforeEach {
                    keychain = MockKeychain()
                }

                it("Should call load on the keychain") {
                    unitUnderTest.loadToken(keychain: keychain)
                    expect(keychain.loadCalled).to(beTrue())
                }

                it("Should not set the token if load does not return data") {
                    keychain.shouldReturnData = false
                    unitUnderTest.loadToken(keychain: keychain)

                    expect(unitUnderTest.token).to(beNil())
                }

                it("Should set the token if load returns data") {
                    keychain.shouldReturnData = true
                    unitUnderTest.loadToken(keychain: keychain)

                    expect(unitUnderTest.token).to(equal("TestData"))
                }
            }

            context("performRequest(_:httpMethod:json:completion:)") {
                var request: URLRequest!

                beforeEach {
                    let url = URL(string: "https://example.url/")!
                    request = URLRequest(url: url)
                }

                it("Should call getFileWithRequest if useLocalFiles is true") {
                    unitUnderTest.useLocalFiles = true
                    let _ = unitUnderTest.performRequest(request, headers: nil, httpMethod: .get, json: nil, completion: { (_, _, _) in })

                    expect(localFileController.getFileWithRequestCalled).to(beTrue())
                }

                it("Should not call json to data if nil json is provided") {
                    let _ = unitUnderTest.performRequest(request, headers: nil, httpMethod: .get, json: nil, completion: { (_, _, _) in })
                    expect(jsonHandler.jsonToDataCalled).to(beFalse())
                }

                it("Should call json to data if json is provided") {
                    let _ = unitUnderTest.performRequest(request, headers: nil, httpMethod: .get, json: [:], completion: { (_, _, _) in })
                    expect(jsonHandler.jsonToDataCalled).to(beTrue())
                }

                it("Should return an error through the completion if the json handler returns an error") {
                    jsonHandler.mockError = true
                    waitUntil { done in
                        let _ = unitUnderTest.performRequest(request, headers: nil, httpMethod: .get, json: [:], completion: { (_, _, outputError) in
                            expect(outputError).toNot(beNil())
                            done()
                        })
                    }
                }

                it("Should call dataTask for a delete request") {
                    let _ = unitUnderTest.performRequest(request, headers: nil, httpMethod: .delete, json: nil, completion: { (_, _, _) in })
                    expect(session.dataTaskWithRequestCalled).to(beTrue())
                }

                it("Should call dataTask for a get request") {
                    let _ = unitUnderTest.performRequest(request, headers: nil, httpMethod: .get, json: nil, completion: { (_, _, _) in })
                    expect(session.dataTaskWithRequestCalled).to(beTrue())
                }

                it("Should call uploadTask for a post request") {
                    let _ = unitUnderTest.performRequest(request, headers: nil, httpMethod: .post, json: nil, completion: { (_, _, _) in })
                    expect(session.uploadTaskCalled).to(beTrue())
                }

                it("Should call uploadTask for a put request") {
                    let _ = unitUnderTest.performRequest(request, headers: nil, httpMethod: .put, json: nil, completion: { (_, _, _) in })
                    expect(session.uploadTaskCalled).to(beTrue())
                }
            }

            context("performRequest(endpoint:parameters:json:httpMethod:completion:)") {
                it("Should add the parameters from the request configuration to the url constructor") {
                    let requestConfiguration = RequestConfiguration(queryParameters: ["key1" : "value1"])
                    let _ = unitUnderTest.performRequest(endpoint: nil, httpMethod: .get, json: nil, requestConfiguration: requestConfiguration, completion: { (_, _, _) in })
                    expect(urlConstructor.parameters as? [String : String]).to(equal(["key1" : "value1"]))
                }

                it("Should call urlWith on the URL Constructor") {
                    let _ = unitUnderTest.performRequest(endpoint: nil, httpMethod: .get, json: nil, requestConfiguration: nil, completion: { (_, _, _) in })
                    expect(urlConstructor.urlWithEndpointCalled).to(beTrue())
                }

                it("Should return an error through the closure if the URL constructor returns an error") {
                    urlConstructor.shouldReturnError = true
                    waitUntil { done in
                        let _ = unitUnderTest.performRequest(endpoint: nil, httpMethod: .get, json: nil, requestConfiguration: nil, completion: { (_, _, outputError) in
                            expect(outputError).toNot(beNil())
                            done()
                        })
                    }
                }
            }

            context("setAuthorizationHeaderOnRequest(_:)") {
                var request: URLRequest!
                var url: URL!

                beforeEach {
                    url = URL(string: "http://testurl.com")!
                    request = URLRequest(url: url)
                }

                it("Should not set an authorization header if token is nil") {
                    unitUnderTest.token = nil
                    let result = unitUnderTest.setAuthorizationHeaderOnRequest(request)

                    expect(result.allHTTPHeaderFields?[RequestController.authorizationHeader]).to(beNil())
                }

                it("Should set an authorization header if a token is present") {
                    unitUnderTest.token = "TestToken"
                    let result = unitUnderTest.setAuthorizationHeaderOnRequest(request)

                    expect(result.allHTTPHeaderFields?[RequestController.authorizationHeader]).to(equal("TestToken"))
                }
            }

            context("setHeadersOnRequest(_:headers:)") {
                var request: URLRequest!
                var url: URL!

                beforeEach {
                    url = URL(string: "http://testurl.com")!
                    request = URLRequest(url: url)
                }

                it("Should return the request if there are no headers") {
                    expect(unitUnderTest.setHeadersOnRequest(request, headers: nil)).to(equal(request))
                }

                it("Should set the provided header values on the request") {
                    let headers = ["testHeader" : "testValue"]
                    let result = unitUnderTest.setHeadersOnRequest(request, headers: headers)

                    expect(result.allHTTPHeaderFields).to(equal(headers))
                }
            }
        }
    }
}
