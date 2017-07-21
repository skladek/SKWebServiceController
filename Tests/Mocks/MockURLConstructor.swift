import Foundation

@testable import SKWebServiceController

class MockURLConstructor: URLConstructable {
    var urlWithEndpointCalled = false
    var baseURL: String = ""
    var parameters: [AnyHashable : Any]? = nil
    var shouldReturnError = false

    func urlWith(endpoint: String?, parameters: [AnyHashable : Any]?) -> URLResult {
        urlWithEndpointCalled = true
        self.parameters = parameters
        let url = shouldReturnError ? nil : URL(string: "https://example.url/")
        let error = shouldReturnError ? NSError(domain: "test.domain", code: 999, userInfo: nil) : nil

        return (url, error)
    }
}
