import Foundation

class MockJSONSerialization: JSONSerialization {
    override class func data(withJSONObject obj: Any, options opt: JSONSerialization.WritingOptions = []) throws -> Data {
        let error = NSError(domain: "test.domain", code: 2345, userInfo: nil)

        throw error
    }
}
