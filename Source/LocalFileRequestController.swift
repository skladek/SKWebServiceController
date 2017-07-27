import UIKit

protocol LocalFileRequestControllerProtocol {
    func getDataFromURL(_ url: URL, completion: @escaping RequestController.RequestCompletion)
    func getFileURLFromRequest(_ request: URLRequest, completion: @escaping RequestController.RequestCompletion) -> URL?
    func getFileWithRequest(_ request: URLRequest, completion: @escaping RequestController.RequestCompletion)
}

class LocalFileRequestController: LocalFileRequestControllerProtocol {

    // MARK: Internal Properties

    let bundle: Bundle

    // MARK: Init Methods

    init(bundle: Bundle = Bundle.main) {
        self.bundle = bundle
    }

    // MARK: Instance Methods

    func getDataFromURL(_ url: URL, completion: @escaping RequestController.RequestCompletion) {
        do {
            let data = try Data(contentsOf: url)
            completion(data, nil, nil)
        } catch {
            completion(nil, nil, error)
            return
        }
    }

    func getFileURLFromRequest(_ request: URLRequest, completion: @escaping RequestController.RequestCompletion) -> URL? {
        guard let lastPathComponent = request.url?.lastPathComponent,
            let path = bundle.path(forResource: lastPathComponent, ofType: ".json") else {
            let error = WebServiceError(code: .noData, message: "A file named \(String(describing: request.url?.lastPathComponent)).json was not found in the main bundle. Currently, only json files are accepted.")
            completion(nil, nil, error)
            return nil
        }

        return URL(fileURLWithPath: path)
    }

    func getFileWithRequest(_ request: URLRequest, completion: @escaping RequestController.RequestCompletion) {
        if let fileURL = getFileURLFromRequest(request, completion: completion) {
            getDataFromURL(fileURL, completion: completion)
        }
    }
}
