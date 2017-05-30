//
//  WebServiceController.swift
//  WebServiceController
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class WebServiceController: NSObject {
    // MARK: Class Types

    /// The completion that is returned with requests.
    typealias RequestCompletion = (Any?, URLResponse?, Error?) -> ()

    // MARK: Static Variables

    /// A singleton instance
    static let sharedInstance = WebServiceController()

    // MARK: Private Class Types

    private enum HTTPMethod: String {
        case delete = "DELETE"
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }

    // MARK: Private Variables

    private let jsonHandler: JSONHandling

    private let session: URLSession

    // MARK: Init Methods

    /// Creates a controller with the defualt values.
    override init() {
        self.jsonHandler = JSONHandler()
        self.session = URLSession(configuration: .default)
    }

    /// Creates a controller with the session and JSON Handler values for testing purposes. Do not use this initializer in production.
    ///
    /// - Parameters:
    ///   - testingSession: The URL session to be used.
    ///   - jsonHandler: The JSON handler to be used.
    init(testingSession: URLSession, jsonHandler: JSONHandling? = nil) {
        self.jsonHandler = jsonHandler ?? JSONHandler()
        self.session = testingSession
    }

    // MARK: Instance Methods


    /// Performs a delete request on the url formed from the base URL and endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The data task to be performed.
    @discardableResult
    func delete(_ endpoint: String? = nil, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        return performRequest(endpoint: endpoint, httpMethod: .delete, completion: completion)
    }

    /// Performs a get request on the url formed from the base URL, endpoint, and parameters.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - parameters: The query parameters to be included in the URL.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The data task to be performed.
    @discardableResult
    func get(_ endpoint: String? = nil, parameters: [String : String]? = nil, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        return performRequest(endpoint: endpoint, parameters: parameters, httpMethod: .get, completion: completion)
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
    func post(_ endpoint: String? = nil, parameters: [String : String]? = nil, json: Any?, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        return performRequest(endpoint: endpoint, parameters: parameters, json: json, httpMethod: .post, completion: completion)
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
    func put(_ endpoint: String? = nil, parameters: [String : String]? = nil, json: Any?, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        return performRequest(endpoint: endpoint, parameters: parameters, json: json, httpMethod: .put, completion: completion)
    }

    // MARK: Private Methods

    private func dataTask(request: URLRequest, completion: @escaping RequestCompletion) -> URLSessionDataTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            self.taskCompletion(data: data, response: response, error: error, completion: completion)
        }

        dataTask.resume()

        return dataTask
    }

    private func performRequest(endpoint: String?, parameters: [String : String]? = nil, json: Any? = nil, httpMethod: HTTPMethod, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        let urlTuple = URLConstructor.urlWith(endpoint: endpoint, parameters: parameters)
        guard let url = urlTuple.url else {
            completion(nil, nil, urlTuple.error)
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue

        var data: Data? = nil
        var sessionTask: URLSessionDataTask? = nil

        if let json = json {
            let convertedJSON = jsonHandler.jsonToData(json)
            if convertedJSON.error != nil {
                completion(nil, nil, convertedJSON.error)
                return nil
            }

            data = convertedJSON.object as? Data
        }

        switch httpMethod {
        case .delete, .get:
            sessionTask = dataTask(request: urlRequest, completion: completion)
        case .post, .put:
            sessionTask = uploadTask(request: urlRequest, data: data, completion: completion)
        }

        return sessionTask
    }

    private func taskCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping RequestCompletion) {
        DispatchQueue.main.async {
            if let error = error {
                completion(nil, response, error)
                return
            }

            let result = self.jsonHandler.dataToJSON(data)
            completion(result.object, response, error)
        }
    }

    private func uploadTask(request: URLRequest, data: Data?, completion: @escaping RequestCompletion) -> URLSessionDataTask {
        let dataTask = session.uploadTask(with: request, from: data) { (data, response, error) in
            self.taskCompletion(data: data, response: response, error: error, completion: completion)
        }

        dataTask.resume()

        return dataTask
    }
}
