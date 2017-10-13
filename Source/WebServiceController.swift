import UIKit

/// Provides a controller for web services.
open class WebServiceController: NSObject {

    // MARK: Public Class Types

    /// The completion that is returned with image requests.
    public typealias ImageCompletion = (UIImage?, URLResponse?, Error?) -> Void

    /// The completion that is returned with JSON requests.
    public typealias JSONCompletion = (Any?, URLResponse?, Error?) -> Void

    // MARK: Static Variables

    static let bearerPrefix = "Bearer "

    // MARK: Public Properties

    /// The base URL used for all requests.
    public var baseURL: String {
        return requester.urlConstructor.baseURL
    }

    /// The authorization token appended to all requests.
    public var token: String? {
        return requester.token
    }

    /// Provides a toggle to utilize local files instead of making an external URL request. This should only be
    /// used for debugging. The local files will be searched for using the last path component. For example, with
    /// the URL http://example.com/test, a file with the name test.json would be searched for in the main bundle.
    public var useLocalFiles: Bool {
        get {
            return requester.useLocalFiles
        } set {
            requester.useLocalFiles = newValue
        }
    }

    // MARK: Internal Class Types

    enum HTTPMethod: String {
        case delete = "DELETE"
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }

    // MARK: Internal Properties

    var keychain: KeychainProtocol

    var requester: Requesting

    // MARK: Init Methods

    /// Creates a controller that will perform requests on the base URL with the default parameters appended to each request.
    ///
    /// - Parameters:
    ///   - baseURL: The URL that all requests are built from.
    ///   - sessionConfiguration: The session configuration object. The default value is URLSessionConfiguration.default
    public init(baseURL: String, sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.keychain = Keychain()

        let jsonHandler = JSONHandler()
        let session = URLSession(configuration: sessionConfiguration)
        let urlConstructor = URLConstructor(baseURL: baseURL)

        self.requester = RequestController(jsonHandler: jsonHandler, session: session, urlConstructor: urlConstructor)
    }

    init(testRequester: Requesting, keychain: KeychainProtocol) {
        self.requester = testRequester
        self.keychain = keychain
    }

    // MARK: Instance Methods

    /// Performs a delete request on the url formed from the base URL and endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - requestConfiguration: A configuration objects affecting only a single request.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The data task to be performed.
    @discardableResult
    open func delete(_ endpoint: String? = nil, requestConfiguration: RequestConfiguration? = nil, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        return requester.performRequest(endpoint: endpoint, json: nil, httpMethod: .delete, requestConfiguration: requestConfiguration, completion: { (data, response, error) in
            self.requester.jsonCompletion(data: data, response: response, error: error, completion: completion)
        })
    }

    /// Performs a get request on the url formed from the base URL, endpoint, and parameters.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - requestConfiguration: A configuration objects affecting only a single request.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The data task to be performed.
    @discardableResult
    open func get(_ endpoint: String? = nil, requestConfiguration: RequestConfiguration? = nil, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        return requester.performRequest(endpoint: endpoint, json: nil, httpMethod: .get, requestConfiguration: requestConfiguration, completion: { (data, response, error) in
            self.requester.jsonCompletion(data: data, response: response, error: error, completion: completion)
        })
    }

    /// Performs a get request on the provided URL.
    ///
    /// - Parameters:
    ///   - url: The URL to perform the GET request on.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The data task to be performed.
    @discardableResult
    open func getImage(_ url: URL, completion: @escaping ImageCompletion) -> URLSessionDataTask? {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        return requester.performRequest(request, httpMethod: .get, json: nil, completion: { (data, response, error) in
            self.requester.imageCompletion(data: data, response: response, error: error, completion: completion)
        })
    }

    /// Performs a post request on the url formed from the base URL, endpoint, and parameters.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - json: The JSON object to be converted to data. This must be a valid JSON object type.
    ///   - requestConfiguration: A configuration objects affecting only a single request.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The upload task to be performed.
    @discardableResult
    open func post(_ endpoint: String? = nil, json: Any?, requestConfiguration: RequestConfiguration? = nil, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        return requester.performRequest(endpoint: endpoint, json: json, httpMethod: .post, requestConfiguration: requestConfiguration, completion: { (data, response, error) in
            self.requester.jsonCompletion(data: data, response: response, error: error, completion: completion)
        })
    }

    /// Performs a put request on the url formed from the base URL, endpoint, and parameters.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - json: The JSON object to be converted to data. This must be a valid JSON object type.
    ///   - requestConfiguration: A configuration objects affecting only a single request.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The upload task to be performed.
    @discardableResult
    open func put(_ endpoint: String? = nil, json: Any?, requestConfiguration: RequestConfiguration? = nil, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        return requester.performRequest(endpoint: endpoint, json: json, httpMethod: .put, requestConfiguration: requestConfiguration, completion: { (data, response, error) in
            self.requester.jsonCompletion(data: data, response: response, error: error, completion: completion)
        })
    }

    /// Clears any set tokens. This will prevent the authorization token from being set on requests.
    open func removeAuthorizationToken() {
        keychain.delete(key: Keychain.authTokenKeychainKey)
        requester.token = nil
    }

    /// Sets the input token as a bearer token. If the token is passed in without the "Bearer " prefix, it will be appended.
    /// If this is set, it will be passed with every request.
    ///
    /// - Parameter token: The token to be set. This can be passed in with or without the "Bearer " prefix.
    /// - Returns: An optional error.
    @discardableResult
    open func setBearerToken(_ token: String?) -> Error? {
        guard var token = token else {
            let error = WebServiceError(code: .invalidData, message: "Cannot set bearer token. The input token was nil.")
            return error
        }

        if !token.hasPrefix(WebServiceController.bearerPrefix) {
            token = "Bearer \(token)"
        }

        if let tokenData = token.data(using: .utf8, allowLossyConversion: false) {
            keychain.save(key: Keychain.authTokenKeychainKey, data: tokenData)
        }

        requester.token = token

        return nil
    }
}
