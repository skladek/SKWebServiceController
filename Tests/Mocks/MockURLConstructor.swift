//
//  MockURLConstructor.swift
//  WebServiceController
//
//  Created by Sean on 6/6/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

@testable import SKWebServiceController

class MockURLConstructor: URLConstructable {
    var urlWithEndpointCalled = false
    var parameters: [String : String]? = nil
    var shouldReturnError = false

    func urlWith(endpoint: String?, parameters: [String : String]?) -> URLResult {
        urlWithEndpointCalled = true
        self.parameters = parameters
        let url = shouldReturnError ? nil : URL(string: "https://example.url/")
        let error = shouldReturnError ? NSError(domain: "test.domain", code: 999, userInfo: nil) : nil

        return (url, error)
    }
}
