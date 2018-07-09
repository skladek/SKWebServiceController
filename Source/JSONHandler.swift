import Foundation

typealias ConvertedJSON<T> = (object: T?, error: Error?)

protocol JSONHandling {
    func dataToJSON<T>(_ data: Data?) -> ConvertedJSON<T>
    func jsonToData(_ jsonObject: Any?) -> ConvertedJSON<Data>
}

class JSONHandler: JSONHandling {

    // MARK: Internal Properties

    let jsonSerialization: JSONSerialization.Type

    // MARK: Init Methods

    init(JSONSerializationType: JSONSerialization.Type = JSONSerialization.self) {
        self.jsonSerialization = JSONSerializationType
    }

    // MARK: Instance Methods

    func dataToJSON<T>(_ data: Data?) -> ConvertedJSON<T> {
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

        guard let typedJSONObject = jsonObject as? T else {
            var receivedTypeString = "nil"

            if let jsonObject = jsonObject {
                receivedTypeString = String(describing: type(of: jsonObject))
            }

            let typeError = WebServiceError(code: .invalidData, message: "The JSON object was not the expected type. Received \(receivedTypeString), expected \(T.self)")
            return (nil, typeError)
        }

        return (typedJSONObject, serializationError)
    }

    func jsonToData(_ jsonObject: Any?) -> ConvertedJSON<Data> {
        guard let jsonObject = jsonObject else {
            let error = WebServiceError(code: .noData, message: "The JSON object to be converted was nil.")
            return (nil, error)
        }

        if !JSONSerialization.isValidJSONObject(jsonObject) {
            let error = WebServiceError(code: .invalidData, message: "The object to be converted was not a valid JSON object.")
            return (nil, error)
        }

        var jsonData: Data? = nil
        var serializationError: Error? = nil

        do {
            jsonData = try jsonSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            serializationError = error
        }

        return (jsonData, serializationError)
    }
}
