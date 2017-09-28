import Foundation

@testable import SKWebServiceController

class MockKeychain: KeychainProtocol {
    var deleteCalled = false
    var loadCalled = false
    var saveCalled = false
    var shouldReturnData = false

    func delete(key: String) {
        deleteCalled = true
    }

    func load(key: String) -> Data? {
        loadCalled = true
        let data = "TestData".data(using: .utf8, allowLossyConversion: false)

        return shouldReturnData ? data : nil
    }

    func save(key: String, data: Data) {
        saveCalled = true
    }
}
