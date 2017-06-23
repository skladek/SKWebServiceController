//
//  URLConstructor.swift
//  WebServiceController
//
//  Created by Sean on 5/24/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

typealias URLResult = (url: URL?, error: NSError?)

protocol URLConstructable {
    func urlWith(endpoint: String?, parameters: [String : String]?) -> URLResult
}

class URLConstructor: URLConstructable {
    // MARK: Class Types

    // MARK: Internal Properties

    let baseURL: String

    // MARK: Init Methods

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    // MARK: Instance Methods

    func urlWith(endpoint: String?, parameters: [String : String]?) -> URLResult {
        var fullURLString = baseURL

        if let endpoint = endpoint {
            fullURLString.append(endpoint)
        }

        if let queryParameterString = self.queryParametersString(parameters) {
            fullURLString.append("?\(queryParameterString)")
        }

        return urlWith(fullURL: fullURLString)
    }

    func urlWith(fullURL: String) -> URLResult {
        guard let url = URL(string: fullURL) else {
            let error = WebServiceError(code: .invalidURL, message: "Could not form a valid URL. Attempted string: \(fullURL)")
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
