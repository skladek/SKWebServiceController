//
//  MockSession.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

class MockSession: URLSession {
    var dataTask: MockURLSesionDataTask? = nil
    var uploadTask: MockURLSessionUploadTask? = nil

    var dataTaskWithRequestCalled = false
    var dataTaskWithURLCalled = false
    var uploadTaskCalled = false

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskWithRequestCalled = true

        return dataTask ?? MockURLSesionDataTask()
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskWithURLCalled = true

        return dataTask ?? MockURLSesionDataTask()
    }

    override func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
        uploadTaskCalled = true
        
        return uploadTask ?? MockURLSessionUploadTask()
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
