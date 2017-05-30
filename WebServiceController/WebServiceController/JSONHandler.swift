//
//  JSONHandler.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

class JSONHandler: JSONHandling {
    let jsonSerialization: JSONSerialization.Type

    init(JSONSerializationType: JSONSerialization.Type = JSONSerialization.self) {
        self.jsonSerialization = JSONSerializationType
    }

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

        var jsonObject: Any? = nil
        var serializationError: Error? = nil

        do {
            jsonObject = try jsonSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            serializationError = error
        }

        return (jsonObject, serializationError)
    }

    /// Converts the provided JSON object into data.
    ///
    /// - Parameter jsonObject: The JSON object to be converted. This must be a valid JSON object.
    /// - Returns: A tuple containing the JSON object or an error.
    func jsonToData(_ jsonObject: Any?) -> ConvertedJSON {
        guard let jsonObject = jsonObject else {
            let error = WebServiceError(code: .noData, message: "The JSON object to be converted was nil.")
            return (nil, error)
        }

        if !JSONSerialization.isValidJSONObject(jsonObject) {
            let error = WebServiceError(code: .invalidData, message: "The object to be converted was not a valid JSON object.")
            return (nil, error)
        }

        var jsonData: Any? = nil
        var serializationError: Error? = nil

        do {
            jsonData = try jsonSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            serializationError = error
        }

        return (jsonData, serializationError)
    }
}
