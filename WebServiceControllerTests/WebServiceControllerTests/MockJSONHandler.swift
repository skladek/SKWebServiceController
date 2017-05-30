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

    func dataToJSON(_ data: Data?) -> ConvertedJSON {
        dataToJSONCalled = true
        return (nil, nil)
    }

    func jsonToData(_ jsonObject: Any?) -> ConvertedJSON {
        return (nil, nil)
    }
}
