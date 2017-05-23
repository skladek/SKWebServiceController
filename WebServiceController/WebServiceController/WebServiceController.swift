//
//  WebServiceController.swift
//  WebServiceController
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class WebServiceController: NSObject {
    // MARK: Static Variables

    /// The url to append all request endpoints onto.
    static let baseURL = kBASE_URL

    /// A singleton instance
    static let sharedInstance = WebServiceController()

    /// A configured URLSession to route requests through.
    fileprivate let session = URLSession(configuration: .default)

    // MARK: Instance Methods

    /// Performs a get request on the concatenated base url and endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to perform the request on.
    ///   - completion: Returns the json object and/or an error.
    func get(_ endpoint: String?, parameters: [String : String]? = nil, completion: @escaping (Any?, Error?) -> ()) {
        let urlTuple = urlWith(endpoint: endpoint, parameters: parameters)

        guard let url = urlTuple.url else {
            completion(nil, urlTuple.error)
            return
        }

        let dataTask = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, error)
                    return
                }

                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    completion(jsonData, error)
                } catch {
                    completion(nil, error)
                }
            }
        }
        
        dataTask.resume()
    }

    func urlWith(endpoint: String? = nil, parameters: [String : String]? = nil) -> (url: URL?, error: NSError?) {
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
