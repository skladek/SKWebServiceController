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

    /// The completion that is returned with image requests.
    typealias ImageCompletion = (UIImage?, URLResponse?, Error?) -> ()

    /// The completion that is returned with JSON requests.
    typealias JSONCompletion = (Any?, URLResponse?, Error?) -> ()

    // MARK: Private Class Types

    private enum HTTPMethod: String {
        case delete = "DELETE"
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }

    typealias RequestCompletion = (Data?, URLResponse?, Error?) -> ()

    // MARK: Private Variables

    private let defaultParameters: [String : String]

    private let jsonHandler: JSONHandling

    private let session: URLSession

    private let urlConstructor: URLConstructor

    // MARK: Init Methods

    /// Creates a controller with the defualt values.
    init(baseURL: String, defaultParameters: [String : String] = [:]) {
        self.defaultParameters = defaultParameters
        self.jsonHandler = JSONHandler()
        self.session = URLSession(configuration: .default)
        self.urlConstructor = URLConstructor(baseURL: baseURL)
    }

    /// Creates a controller with the session and JSON Handler values for testing purposes. Do not use this initializer in production.
    ///
    /// - Parameters:
    ///   - testingSession: The URL session to be used.
    ///   - jsonHandler: The JSON handler to be used.
    init(testingBaseURL: String, defaultParameters: [String : String], session: URLSession, jsonHandler: JSONHandling? = nil) {
        self.defaultParameters = defaultParameters
        self.jsonHandler = jsonHandler ?? JSONHandler()
        self.session = session
        self.urlConstructor = URLConstructor(baseURL: testingBaseURL)
    }

    // MARK: Instance Methods


    /// Performs a delete request on the url formed from the base URL and endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The data task to be performed.
    @discardableResult
    func delete(_ endpoint: String? = nil, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        return performRequest(endpoint: endpoint, httpMethod: .delete, completion: { (data, response, error) in
            self.jsonCompletion(data: data, response: response, error: error, completion: completion)
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
    func get(_ endpoint: String? = nil, parameters: [String : String]? = nil, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        return performRequest(endpoint: endpoint, parameters: parameters, httpMethod: .get, completion: { (data, response, error) in
            self.jsonCompletion(data: data, response: response, error: error, completion: completion)
        })
    }

    /// Performs a get request on the provided URL.
    ///
    /// - Parameters:
    ///   - url: The URL to perform the GET request on.
    ///   - completion: The closure called when the request completes.
    /// - Returns: The data task to be performed.
    @discardableResult
    func getImage(_ url: URL, completion: @escaping ImageCompletion) -> URLSessionDataTask? {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        return performRequest(request, httpMethod: .get, completion: { (data, response, error) in
            self.imageCompletion(data: data, response: response, error: error, completion: completion)
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
    func post(_ endpoint: String? = nil, parameters: [String : String]? = nil, json: Any?, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        return performRequest(endpoint: endpoint, parameters: parameters, json: json, httpMethod: .post, completion: { (data, response, error) in
            self.jsonCompletion(data: data, response: response, error: error, completion: completion)
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
    func put(_ endpoint: String? = nil, parameters: [String : String]? = nil, json: Any?, completion: @escaping JSONCompletion) -> URLSessionDataTask? {
        return performRequest(endpoint: endpoint, parameters: parameters, json: json, httpMethod: .put, completion: { (data, response, error) in
            self.jsonCompletion(data: data, response: response, error: error, completion: completion)
        })
    }

    // MARK: Private Methods

    private func dataTask(request: URLRequest, completion: @escaping RequestCompletion) -> URLSessionDataTask {
        let dataTask = session.dataTask(with: request, completionHandler: completion)
        dataTask.resume()

        return dataTask
    }

    private func imageCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping ImageCompletion) {
        DispatchQueue.main.async {
            guard let data = data else {
                completion(nil, response, error)
                return
            }

            let image = UIImage(data: data)
            completion(image, response, error)
        }
    }

    private func jsonCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping JSONCompletion) {
        DispatchQueue.main.async {
            guard let data = data else {
                completion(nil, response, error)
                return
            }

            let result = self.jsonHandler.dataToJSON(data)
            completion(result.object, response, result.error ?? error)
        }
    }

    private func performRequest(_ request: URLRequest, httpMethod: HTTPMethod, json: Any? = nil, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
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
            sessionTask = dataTask(request: request, completion: completion)
        case .post, .put:
            sessionTask = uploadTask(request: request, data: data, completion: completion)
        }

        return sessionTask
    }

    private func performRequest(endpoint: String?, parameters: [String : String]? = nil, json: Any? = nil, httpMethod: HTTPMethod, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        var combinedParameters = defaultParameters
        parameters?.forEach{ (key, value) in combinedParameters[key] = value }
        let urlTuple = urlConstructor.urlWith(endpoint: endpoint, parameters: combinedParameters)

        guard let url = urlTuple.url else {
            completion(nil, nil, urlTuple.error)
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        return performRequest(request, httpMethod: httpMethod, json: json, completion: completion)
    }

    private func uploadTask(request: URLRequest, data: Data?, completion: @escaping RequestCompletion) -> URLSessionDataTask {
        let dataTask = session.uploadTask(with: request, from: data, completionHandler: completion)
        dataTask.resume()
        
        return dataTask
    }
}
