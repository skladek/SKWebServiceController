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

    typealias RequestCompletion = (Any?, Error?) -> ()

    typealias URLTuple = (url: URL?, error: NSError?)

    // MARK: Static Variables

    /// The url to append all request endpoints onto.
    static let baseURL = kBASE_URL

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
    func get(_ endpoint: String? = nil, parameters: [String : String]? = nil, completion: @escaping RequestCompletion) {
        let urlTuple = urlWith(endpoint: endpoint, parameters: parameters)

        guard let url = urlTuple.url else {
            completion(nil, urlTuple.error)
            return
        }

        let dataTask = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }

                self.deserializer.dataToJSON(data, completion: completion)
            }
        }
        
        dataTask.resume()
    }



    func urlWith(endpoint: String? = nil, parameters: [String : String]? = nil) -> URLTuple {
        var fullURLString = WebServiceController.baseURL

        if let endpoint = endpoint {
            fullURLString.append(endpoint)
        }

        if let queryParameterString = self.queryParametersString(parameters) {
            fullURLString.append("?\(queryParameterString)")
        }

        guard let url = URL(string: fullURLString) else {
            let error = WebServiceError(code: .invalidURL, message: "Could not form a valid URL from the base URL and the endpoint. Attempted string: \(fullURLString)")
            return (nil, error)
        }

        return (url, nil)
    }

    func queryParametersString(_ parametersDictionary: [String : String]? = nil) -> String? {
        guard let parametersDictionary = parametersDictionary else {
            return nil
        }

        var parametersArray = [String]()

        for key in parametersDictionary.keys.sorted() {
            if let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let encodedValue = parametersDictionary[key]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                parametersArray.append("\(encodedKey)=\(encodedValue)")
            }
        }

        let parametersString = parametersArray.joined(separator: "&")

        return (parametersString.isEmpty) ? nil : parametersString
    }
}
