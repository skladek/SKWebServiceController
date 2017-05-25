//
//  MockSession.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

class MockSession: URLSession {
    var shouldReturnError = false

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let error = shouldReturnError ? NSError(domain: "test.domain", code: 1234, userInfo: nil) : nil
        completionHandler(nil, nil, error)

        return MockURLSesionDataTask()
    }

    override func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
        let error = shouldReturnError ? NSError(domain: "test.domain", code: 5678, userInfo: nil) : nil
        completionHandler(nil, nil, error)

        return MockURLSessionUploadTask()
    }
}

class MockURLSesionDataTask: URLSessionDataTask {
    override func resume() {
        // NO OP
    }
}

class MockURLSessionUploadTask: URLSessionUploadTask {
    override func resume() {
        // NO OP
    }
}
