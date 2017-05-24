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

    typealias RequestCompletion = (Any?, URLResponse?, Error?) -> ()

    // MARK: Static Variables

    /// A singleton instance
    static let sharedInstance = WebServiceController()

    fileprivate let deserializer: JSONDeserializing

    /// A configured URLSession to route requests through.
    fileprivate let session: URLSession

    override init() {
        self.deserializer = WebServiceJSONDeserializer()
        self.session = URLSession(configuration: .default)
    }

    init(testingSession: URLSession, deserializer: JSONDeserializing? = nil) {
        self.deserializer = deserializer ?? WebServiceJSONDeserializer()
        self.session = testingSession
    }

    // MARK: Instance Methods

    /// Performs a get request on the concatenated base url and endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - completion: Returns the json object and/or an error.
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

    @discardableResult
    func post(_ endpoint: String? = nil, parameters: [String : String]? = nil, data: Data?, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        let urlTuple = URLConstructor.urlWith(endpoint: endpoint, parameters: parameters)
        guard let url = urlTuple.url else {
            completion(nil, nil, urlTuple.error)
            return nil
        }

        let urlRequest = URLRequest(url: url)
        let dataTask = session.uploadTask(with: urlRequest, from: data) { (data, response, error) in
            self.taskCompletion(data: data, response: response, error: error, completion: completion)
        }

        dataTask.resume()

        return dataTask
    }

    fileprivate func taskCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping RequestCompletion) {
        DispatchQueue.main.async {
            if let error = error {
                completion(nil, response, error)
                return
            }

            self.deserializer.dataToJSON(data, completion: { (objects, error) in
                completion(objects, response, error)
            })
        }
    }
}
