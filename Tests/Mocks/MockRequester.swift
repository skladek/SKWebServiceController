import Foundation

@testable import SKWebServiceController

class MockRequester: Requesting {
    var dataCompletionCalled = false
    var dataTask: URLSessionDataTask?
    var imageCompletionCalled = false
    var jsonCompletionCalled = false
    var performRequestCalled = false
    var performRequestWithDataAndEndpointCalled = false
    var performRequestWithJSONAndEndpointCalled = false
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

    func jsonCompletion<T>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping WebServiceController.JSONCompletion<T>) {
        jsonCompletionCalled = true

        completion(nil, nil, nil)
    }

    func performRequest(_ request: URLRequest, data: Data?, headers: [AnyHashable: Any]?, httpMethod: WebServiceController.HTTPMethod, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        self.request = request
        performRequestCalled = true
        completion(nil, nil, nil)

        return dataTask
    }

    func performRequest(data: Data?, endpoint: String?, httpMethod: WebServiceController.HTTPMethod, requestConfiguration: RequestConfiguration?, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        performRequestWithDataAndEndpointCalled = true
        completion(nil, nil, nil)

        return dataTask
    }

    func performRequest(endpoint: String?, httpMethod: WebServiceController.HTTPMethod, json: Any?, requestConfiguration: RequestConfiguration?, completion: @escaping Requesting.RequestCompletion) -> URLSessionDataTask? {
        performRequestWithJSONAndEndpointCalled = true
        completion(nil, nil, nil)

        return dataTask
    }
}
