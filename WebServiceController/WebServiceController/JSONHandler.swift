//
//  JSONHandler.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

class JSONHandler: JSONHandling {
    // MARK: Instance Methods

    /// Converts the provided data into a JSON object.
    ///
    /// - Parameter data: The data to be converted into a JSON object.
    /// - Returns: A tuple containing the JSON object or an error.
    func dataToJSON(_ data: Data?) -> ConvertedJSON {
        guard let data = data else {
            let error = WebServiceError(code: .noData, message: "The server returned without error and without data.")
            return (nil, error)
        }

        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return (jsonData, nil)
        } catch {
            return (nil, error)
        }
    }

    /// Converts the provided JSON object into data.
    ///
    /// - Parameter jsonObject: The JSON object to be converted. This must be a valid JSON object.
    /// - Returns: A tuple containing the JSON object or an error.
    func jsonToData(_ jsonObject: Any?) -> ConvertedJSON {
        guard let jsonObject = jsonObject else {
            let error = WebServiceError(code: .noData, message: "The json object to be converted was nil.")
            return (nil, error)
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            return (data, nil)
        } catch {
            return (nil, error)
        }
    }
}
