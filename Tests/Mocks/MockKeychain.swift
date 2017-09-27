import Foundation

@testable import SKWebServiceController

class MockKeychain: KeychainProtocol {
    var deleteCalled = false
    var loadCalled = false
    var saveCalled = false

    func delete(key: String) {
        deleteCalled = true
    }

    func load(key: String) -> Data? {
        loadCalled = true

        return nil
    }

    func save(key: String, data: Data) {
        saveCalled = true
    }
}
