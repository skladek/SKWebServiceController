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

    /// An initializer to create a controller with default values.
    override init() {
        self.jsonHandler = JSONHandler()
        self.session = URLSession(configuration: .default)
    }

    /// An initializer to take session and JSON Handler values for testing purposes. Do not use this initializer in production.
    ///
    /// - Parameters:
    ///   - testingSession: The URL session to be used.
    ///   - jsonHandler: The JSON handler to be used.
    init(testingSession: URLSession, jsonHandler: JSONHandling? = nil) {
        self.jsonHandler = jsonHandler ?? JSONHandler()
        self.session = testingSession
    }

    // MARK: Instance Methods

    @discardableResult
    func delete(_ endpoint: String, completion: @escaping RequestCompletion) -> URLSessionTask? {
        let urlTuple = URLConstructor.urlWith(endpoint: endpoint, parameters: nil)

        guard let url = urlTuple.url else {
            completion(nil, nil, urlTuple.error)
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.delete.rawValue
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            self.taskCompletion(data: data, response: response, error: error, completion: completion)
        }

        dataTask.resume()
        
        return dataTask
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
        let urlTuple = URLConstructor.urlWith(endpoint: endpoint, parameters: parameters)

        guard let url = urlTuple.url else {
            completion(nil, nil, urlTuple.error)
            return nil
        }

        let dataTask = session.dataTask(with: url) { (data, response, error) in
            self.taskCompletion(data: data, response: response, error: error, completion: completion)
        }

        dataTask.resume()

        return dataTask
    }

    /// Performs a post request on the url formed from the base URL, endpoint, and parameters.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - parameters: The query parameters to be included in the URL.
    ///   - json: The JSON object to be converted to data. This must be a valid JSON object type.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The data task to be performed.
    @discardableResult
    func post(_ endpoint: String? = nil, parameters: [String : String]? = nil, json: Any?, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        return postPut(endpoint, parameters: parameters, json: json, httpMethod: .post, completion: completion)
    }

    /// Performs a put request on the url formed from the base URL, endpoint, and parameters.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - parameters: The query parameters to be included in the URL.
    ///   - json: The JSON object to be converted to data. This must be a valid JSON object type.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The data task to be performed.
    @discardableResult
    func put(_ endpoint: String? = nil, parameters: [String : String]? = nil, json: Any?, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        return postPut(endpoint, parameters: parameters, json: json, httpMethod: .put, completion: completion)
    }

    // MARK: Private Methods

    private func postPut(_ endpoint: String? = nil, parameters: [String : String]? = nil, json: Any?, httpMethod: HTTPMethod, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        let urlTuple = URLConstructor.urlWith(endpoint: endpoint, parameters: parameters)
        guard let url = urlTuple.url else {
            completion(nil, nil, urlTuple.error)
            return nil
        }

        let convertedJSON = jsonHandler.jsonToData(json)
        if convertedJSON.error != nil {
            completion(nil, nil, convertedJSON.error)
            return nil
        }

        let data = convertedJSON.object as? Data

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        let dataTask = session.uploadTask(with: urlRequest, from: data) { (data, response, error) in
            self.taskCompletion(data: data, response: response, error: error, completion: completion)
        }

        dataTask.resume()
        
        return dataTask
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
}
