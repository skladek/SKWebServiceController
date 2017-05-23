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
    func get(_ endpoint: String, completion: @escaping (Any?, Error?) -> ()) {
        let fullURLString = WebServiceController.baseURL.appending(endpoint)
        guard let fullURL = URL(string: fullURLString) else {
            let error = NSError(code: -1, message: "Invalid URL")
            completion(nil, error)
            return
        }

        let dataTask = session.dataTask(with: fullURL) { (data, response, error) in
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
}

extension NSError {
    convenience init(code: Int, message: String?) {
        var localizedDescription = message

        if message == nil {
            localizedDescription = "An unknown error occurred."
        }

        var userInfo: [AnyHashable : Any]? = nil
        if let message = localizedDescription {
            userInfo = [NSLocalizedDescriptionKey : message]
        }

        let domain = Bundle.main.bundleIdentifier ?? ""

        self.init(domain: domain, code: code, userInfo: userInfo)
    }
}
