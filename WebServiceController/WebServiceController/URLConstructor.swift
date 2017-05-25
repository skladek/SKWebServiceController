//
//  URLConstructor.swift
//  WebServiceController
//
//  Created by Sean on 5/24/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class URLConstructor: NSObject {
    // MARK: Class Types

    /// A tuple containing the constructed URL or an error explaining why the URL could not be constructed.
    typealias URLResult = (url: URL?, error: NSError?)

    /// The url to append all request endpoints onto.
    static fileprivate let baseURL = kBASE_URL

    /// Constructs a URL from the base URL build setting, endpoint, and parameters.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to append to the base url
    ///   - parameters: A dictionary of query parameters to include in the URL
    /// - Returns: A result object with the URL or an error.
    class func urlWith(endpoint: String?, parameters: [String : String]?) -> URLResult {
        var fullURLString = URLConstructor.baseURL

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

    /// Transforms the parameters dictionary into a string representation ("key1=value1&key2=value2")
    ///
    /// - Parameter parametersDictionary: The dictionary to transform into a string representation.
    /// - Returns: The string representation or nil if there are no parameters.
    class func queryParametersString(_ parametersDictionary: [String : String]? = nil) -> String? {
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
