import Foundation

@testable import SKWebServiceController

class MockLocalFileRequestController: LocalFileRequestControllerProtocol {
    var getFileWithRequestCalled = false

    func getDataFromURL(_ url: URL, completion: @escaping Requesting.RequestCompletion) {}

    func getFileURLFromRequest(_ request: URLRequest, completion: @escaping Requesting.RequestCompletion) -> URL? {
        return nil
    }

    func getFileWithRequest(_ request: URLRequest, completion: @escaping Requesting.RequestCompletion) {
        getFileWithRequestCalled = true
    }
}
