import Foundation

typealias ConvertedJSON = (object: Any?, error: Error?)

protocol JSONHandling {
    func dataToJSON(_ data: Data?) -> ConvertedJSON
    func jsonToData(_ jsonObject: Any?) -> ConvertedJSON
}

class JSONHandler: JSONHandling {

    // MARK: Internal Properties

    let jsonSerialization: JSONSerialization.Type

    // MARK: Init Methods

    init(JSONSerializationType: JSONSerialization.Type = JSONSerialization.self) {
        self.jsonSerialization = JSONSerializationType
    }

    // MARK: Instance Methods

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
