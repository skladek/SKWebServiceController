import Foundation

extension Dictionary {

    // MARK: Instance Methods

    func toStringDictionary() -> [String: String] {
        var stringDictionary: [String: String] = [:]

        for key in self.keys {
            if let value = self[key] {
                let stringKey = self.stringValue(key)
                let stringValue = self.stringValue(value)

                stringDictionary[stringKey] = stringValue
            }
        }

        return stringDictionary
    }

    func stringValue(_ object: Any) -> String {
        var value = ""

        if let boolean = object as? Bool {
            value = boolean ? "1" : "0"
        } else {
            value = String(describing: object)
        }

        return value
    }
}
