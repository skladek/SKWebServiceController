import UIKit

struct Post {
    struct DictionaryKeys {
        static let body = "body"
        static let identifier = "id"
        static let title = "title"
        static let userId = "userId"
    }

    var body: String
    let identifier: Int?
    var title: String
    let userId: Int?

    init() {
        self.body = ""
        self.identifier = nil
        self.title = ""
        self.userId = nil
    }

    init(dictionary: [String: Any]) {
        self.body = dictionary[DictionaryKeys.body] as? String ?? ""
        self.identifier = dictionary[DictionaryKeys.identifier] as? Int
        self.title = dictionary[DictionaryKeys.title] as? String ?? ""
        self.userId = dictionary[DictionaryKeys.userId] as? Int
    }

    func toJSON() -> [String: String] {
        return [
            DictionaryKeys.body: body,
            DictionaryKeys.title: title
        ]
    }
}
