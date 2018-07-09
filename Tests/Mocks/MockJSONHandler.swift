import Foundation

@testable import SKWebServiceController

class MockJSONHandler: JSONHandling {
    var dataToJSONCalled = false
    var jsonToDataCalled = false
    var mockError = false

    func dataToJSON<T>(_ data: Data?) -> ConvertedJSON<T> {
        dataToJSONCalled = true
        let error = mockError ? NSError(domain: "test.domain", code: 999, userInfo: nil) : nil

        return (nil, error)
    }

    func jsonToData(_ jsonObject: Any?) -> ConvertedJSON<Data> {
        jsonToDataCalled = true
        let error = mockError ? NSError(domain: "test.domain", code: 999, userInfo: nil) : nil

        return (nil, error)
    }
}
