//
//  WebServiceController.swift
//  WebServiceController
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

open class WebServiceController: NSObject {

    // MARK: Public Class Types

    /// The completion that is returned with image requests.
    public typealias ImageCompletion = (UIImage?, URLResponse?, Error?) -> Void

    /// The completion that is returned with JSON requests.
    public typealias JSONCompletion = (Any?, URLResponse?, Error?) -> Void

    // MARK: Internal Class Types

    enum HTTPMethod: String {
        case delete = "DELETE"
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }

    // MARK: Internal Properties

    let requester: Requesting

    // MARK: Init Methods

    /// Creates a controller that will perform requests on the base URL with the default parameters appended to each request.
    ///
    /// - Parameters:
    ///   - baseURL: The URL that all requests are built from.
    ///   - defaultParameters: The parameters to be appended to the end of the URL string.
    public init(baseURL: String, defaultParameters: [String : String] = [:]) {
        let jsonHandler = JSONHandler()
        let session = URLSession(configuration: .default)
        let urlConstructor = URLConstructor(baseURL: baseURL)
        self.requester = Requester(defaultParameters: defaultParameters, jsonHandler: jsonHandler, session: session, urlConstructor: urlConstructor)
    }

    init(testRequester: Requesting) {
        self.requester = testRequester
    }

    // MARK: Instance Methods

    /// Performs a delete request on the url formed from the base URL and endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The data task to be performed.
    @discardableResult
    public func delete(_ endpoint: String? = nil, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        return requester.performRequest(endpoint: endpoint, parameters: nil, json: nil, httpMethod: .delete, completion: { (data, response, error) in
            self.requester.jsonCompletion(data: data, response: response, error: error, completion: completion)
        })
    }

    /// Performs a get request on the url formed from the base URL, endpoint, and parameters.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - parameters: The query parameters to be included in the URL.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The data task to be performed.
    @discardableResult
    public func get(_ endpoint: String? = nil, parameters: [String : String]? = nil, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        return requester.performRequest(endpoint: endpoint, parameters: parameters, json: nil, httpMethod: .get, completion: { (data, response, error) in
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
    public func getImage(_ url: URL, completion: @escaping ImageCompletion) -> URLSessionDataTask? {
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
    ///   - parameters: The query parameters to be included in the URL.
    ///   - json: The JSON object to be converted to data. This must be a valid JSON object type.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The upload task to be performed.
    @discardableResult
    public func post(_ endpoint: String? = nil, parameters: [String : String]? = nil, json: Any?, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        return requester.performRequest(endpoint: endpoint, parameters: parameters, json: json, httpMethod: .post, completion: { (data, response, error) in
            self.requester.jsonCompletion(data: data, response: response, error: error, completion: completion)
        })
    }

    /// Performs a put request on the url formed from the base URL, endpoint, and parameters.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - parameters: The query parameters to be included in the URL.
    ///   - json: The JSON object to be converted to data. This must be a valid JSON object type.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The upload task to be performed.
    @discardableResult
    public func put(_ endpoint: String? = nil, parameters: [String : String]? = nil, json: Any?, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        return requester.performRequest(endpoint: endpoint, parameters: parameters, json: json, httpMethod: .put, completion: { (data, response, error) in
            self.requester.jsonCompletion(data: data, response: response, error: error, completion: completion)
        })
    }
}
