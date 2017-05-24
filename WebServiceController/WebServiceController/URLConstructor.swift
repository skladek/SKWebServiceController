//
//  URLConstructor.swift
//  WebServiceController
//
//  Created by Sean on 5/24/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class URLConstructor: NSObject {
    typealias URLResult = (url: URL?, error: NSError?)

    /// The url to append all request endpoints onto.
    static fileprivate let baseURL = kBASE_URL

    class func urlWith(endpoint: String? = nil, parameters: [String : String]? = nil) -> URLResult {
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
