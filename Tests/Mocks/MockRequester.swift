import Foundation

@testable import SKWebServiceController

class MockRequester: Requesting {
    var dataCompletionCalled = false
    var dataTask: URLSessionDataTask?
    var imageCompletionCalled = false
    var jsonCompletionCalled = false
    var performRequestCalled = false
    var performRequestWithEndpointCalled = false
    var request: URLRequest? = nil
    var token: String? = nil
    var urlConstructor: URLConstructable = URLConstructor(baseURL: "")
    var useLocalFiles: Bool = false

    init(baseURL: String = "", token: String = "") {
        self.token = token
        urlConstructor = URLConstructor(baseURL: baseURL)
    }

    func dataCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping WebServiceController.DataCompletion) {
        dataCompletionCalled = true

        completion(nil, nil, nil)
    }

    func imageCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping WebServiceController.ImageCompletion) {
        imageCompletionCalled = true

        completion(nil, nil, nil)
    }

    func jsonCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping WebServiceController.JSONCompletion) {
        jsonCompletionCalled = true

        completion(nil, nil, nil)
    }

    func performRequest(_ request: URLRequest, headers: [AnyHashable: Any]?, httpMethod: WebServiceController.HTTPMethod, json: Any?, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        self.request = request
        performRequestCalled = true
        completion(nil, nil, nil)

        return dataTask
    }

    func performRequest(endpoint: String?, httpMethod: WebServiceController.HTTPMethod, json: Any?, requestConfiguration: RequestConfiguration?, completion: @escaping Requesting.RequestCompletion) -> URLSessionDataTask? {
        performRequestWithEndpointCalled = true
        completion(nil, nil, nil)

        return dataTask
    }
}
