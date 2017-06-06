//
//  MockDeserializer.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

@testable import WebServiceController

class MockJSONHandler: JSONHandling {
    var dataToJSONCalled = false
    var jsonToDataCalled = false
    var mockError = false

    func dataToJSON(_ data: Data?) -> ConvertedJSON {
        dataToJSONCalled = true
        let error = mockError ? NSError(domain: "test.domain", code: 999, userInfo: nil) : nil

        return (nil, error)
    }

    func jsonToData(_ jsonObject: Any?) -> ConvertedJSON {
        jsonToDataCalled = true
        let error = mockError ? NSError(domain: "test.domain", code: 999, userInfo: nil) : nil

        return (nil, error)
    }
}
