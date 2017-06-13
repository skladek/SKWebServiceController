//
//  MockRequester.swift
//  WebServiceController
//
//  Created by Sean on 6/6/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

@testable import SKWebServiceController

class MockRequester: Requesting {
    var dataTask: URLSessionDataTask?
    var imageCompletionCalled = false
    var jsonCompletionCalled = false
    var performRequestCalled = false
    var performRequestWithEndpointCalled = false
    var request: URLRequest? = nil

    func imageCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping WebServiceController.ImageCompletion) {
        imageCompletionCalled = true

        completion(nil, nil, nil)
    }

    func jsonCompletion(data: Data?, response: URLResponse?, error: Error?, completion: @escaping WebServiceController.JSONCompletion) {
        jsonCompletionCalled = true

        completion(nil, nil, nil)
    }

    func performRequest(_ request: URLRequest, httpMethod: WebServiceController.HTTPMethod, json: Any?, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        self.request = request
        performRequestCalled = true
        completion(nil, nil, nil)

        return dataTask
    }

    func performRequest(endpoint: String?, parameters: [String : String]?, json: Any?, httpMethod: WebServiceController.HTTPMethod, completion: @escaping RequestCompletion) -> URLSessionDataTask? {
        performRequestWithEndpointCalled = true
        completion(nil, nil, nil)

        return dataTask
    }
}
