import Foundation
import UIKit

protocol Requesting {
    typealias RequestCompletion = (Data?, URLResponse?, Error?) -> Void

    func imageCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping WebServiceController.ImageCompletion)
    func jsonCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping WebServiceController.JSONCompletion)
    func performRequest(_ request: URLRequest, httpMethod: WebServiceController.HTTPMethod, json: Any?, completion: @escaping RequestCompletion) -> URLSessionDataTask?
    func performRequest(endpoint: String?, json: Any?, httpMethod: WebServiceController.HTTPMethod, requestConfiguration: RequestConfiguration?, completion: @escaping RequestCompletion) -> URLSessionDataTask?
}

class RequestController: Requesting {

    let jsonHandler: JSONHandling
    let session: URLSession
    let urlConstructor: URLConstructable

    init(jsonHandler: JSONHandling, session: URLSession, urlConstructor: URLConstructable) {
        self.jsonHandler = jsonHandler
        self.session = session
        self.urlConstructor = urlConstructor
    }

    func dataTask(request: URLRequest, completion: @escaping RequestCompletion) -> URLSessionDataTask {
        let dataTask = session.dataTask(with: request, completionHandler: completion)
        dataTask.resume()

        return dataTask
    }

    func imageCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping WebServiceController.ImageCompletion) {
        DispatchQueue.main.async {
            if let error = error {
                completion(nil, response, error)
                return
            }

            guard let data = data else {
                completion(nil, response, error)
                return
            }

            let image = UIImage(data: data)
            completion(image, response, error)
        }
    }

    func jsonCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping WebServiceController.JSONCompletion) {
        DispatchQueue.main.async {
            if let error = error {
                completion(nil, response, error)
                return
            }

            let result = self.jsonHandler.dataToJSON(data)
            completion(result.object, response, result.error)
        }
    }

    func performRequest(_ request: URLRequest, httpMethod: WebServiceController.HTTPMethod, json: Any?, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        var data: Data? = nil
        var sessionTask: URLSessionDataTask? = nil

        if let json = json {
            let convertedJSON = jsonHandler.jsonToData(json)
            if convertedJSON.error != nil {
                completion(nil, nil, convertedJSON.error)
                return nil
            }

            data = convertedJSON.object as? Data
        }

        switch httpMethod {
        case .delete, .get:
            sessionTask = dataTask(request: request, completion: completion)
        case .post, .put:
            sessionTask = uploadTask(request: request, data: data, completion: completion)
        }

        return sessionTask
    }

    func performRequest(endpoint: String?, json: Any?, httpMethod: WebServiceController.HTTPMethod, requestConfiguration: RequestConfiguration?, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        let urlTuple = urlConstructor.urlWith(endpoint: endpoint, parameters: requestConfiguration?.queryParameters)

        guard let url = urlTuple.url else {
            completion(nil, nil, urlTuple.error)
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request = setHeadersOnRequest(request, headers: requestConfiguration?.additionalHTTPHeaders)

        return performRequest(request, httpMethod: httpMethod, json: json, completion: completion)
    }

    func setHeadersOnRequest(_ request: URLRequest, headers: [AnyHashable : Any]?) -> URLRequest {
        guard let headers = headers else {
            return request
        }

        var mutableRequest = request

        for key in headers.keys {
            if let object = headers[key] {
                let stringValue = String(describing: object)
                let stringKey = String(describing: key)
                mutableRequest.setValue(stringValue, forHTTPHeaderField: stringKey)
            }
        }

        return mutableRequest
    }

    func uploadTask(request: URLRequest, data: Data?, completion: @escaping RequestCompletion) -> URLSessionDataTask {
        let dataTask = session.uploadTask(with: request, from: data, completionHandler: completion)
        dataTask.resume()

        return dataTask
    }
}
