import UIKit

class LocalFileRequestController {
    func getDataFromURL(_ url: URL, completion: @escaping RequestController.RequestCompletion) {
        do {
            let data = try Data(contentsOf: url)
            completion(data, nil, nil)
        } catch {
            completion(nil, nil, error)
            return
        }
    }

    func getFileWithRequest(_ request: URLRequest, completion: @escaping RequestController.RequestCompletion) {
        guard let fileURL = getFileURLFromRequest(request, completion: completion) else {
            return
        }

        getDataFromURL(fileURL, completion: completion)
    }

    func getFileURLFromRequest(_ request: URLRequest, completion: @escaping RequestController.RequestCompletion) -> URL? {
        guard let lastPathComponent = request.url?.lastPathComponent else {
            let error = WebServiceError(code: .noData, message: "The last path component was not found for the URL: \(String(describing: request.url)).")
            completion(nil, nil, error)
            return nil
        }

        guard let path = Bundle.main.path(forResource: lastPathComponent, ofType: ".json") else {
            let error = WebServiceError(code: .noData, message: "A file named \(lastPathComponent).json was not found in the main bundle. Currently, only json files are accepted.")
            completion(nil, nil, error)
            return nil
        }

        return URL(fileURLWithPath: path)
    }
}
