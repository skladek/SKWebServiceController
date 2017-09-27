import Foundation
import Nimble
import Quick

@testable import SKWebServiceController

class WebServiceControllerSpec: QuickSpec {
    override func spec() {
        var keychain: MockKeychain!
        var requester: MockRequester!
        var unitUnderTest: WebServiceController!

        beforeEach {
            keychain = MockKeychain()
            requester = MockRequester()
            unitUnderTest = WebServiceController(testRequester: requester, keychain: keychain)
        }

        describe("WebServiceController") {
            context("init(baseURL:defaultParameters:)") {
                var baseURL: String!

                beforeEach {
                    baseURL = "https://testbaseurl.com"

                    unitUnderTest = WebServiceController(baseURL: baseURL)
                }

                it("Should pass the base URL to the URLConstructor") {
                    expect(((unitUnderTest.requester as! RequestController).urlConstructor as! URLConstructor).baseURL).to(equal(baseURL))
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

            context("removeAuthorizationToken()") {
                it("Should remove any set authorization token from the requester") {
                    unitUnderTest.requester.token = "Test Token"
                    unitUnderTest.removeAuthorizationToken()
                    expect(unitUnderTest.requester.token).to(beNil())
                }
            }

            context("setBearerToken(_:)") {
                it("Should set the token on the requester") {
                    unitUnderTest.setBearerToken("Bearer TestToken")
                    expect(unitUnderTest.requester.token).to(equal("Bearer TestToken"))
                }

                it("Should append the Bearer prefix if the input token does not contain it") {
                    unitUnderTest.setBearerToken("TestToken")
                    expect(unitUnderTest.requester.token).to(equal("Bearer TestToken"))
                }

                it("Should return an error if the input string is nil") {
                    let result = unitUnderTest.setBearerToken(nil)
                    expect((result as NSError?)?.code).to(equal(WebServiceError.Code.invalidData.rawValue))
                }
            }

            context("baseURL") {
                it("Should return the baseURL from the URLConstructor") {
                    let requester = MockRequester(baseURL: "testBaseURL")
                    unitUnderTest = WebServiceController(testRequester: requester, keychain: keychain)

                    expect(unitUnderTest.baseURL).to(equal("testBaseURL"))
                }
            }

            context("token") {
                it("Should return the token value from the requester") {
                    requester = MockRequester(token: "TestToken")
                    unitUnderTest = WebServiceController(testRequester: requester, keychain: keychain)

                    expect(unitUnderTest.token).to(equal("TestToken"))
                }
            }

            context("useLocalFiles") {
                it("Should return the useLocalFiles value from the requester") {
                    requester = MockRequester()
                    requester.useLocalFiles = true
                    unitUnderTest = WebServiceController(testRequester: requester, keychain: keychain)

                    expect(unitUnderTest.useLocalFiles).to(beTrue())
                }

                it("Should set the useLocalFiles value on the requester") {
                    requester = MockRequester()
                    requester.useLocalFiles = true
                    unitUnderTest = WebServiceController(testRequester: requester, keychain: keychain)
                    unitUnderTest.useLocalFiles = false

                    expect(requester.useLocalFiles).to(beFalse())
                }
            }
        }
    }
}
