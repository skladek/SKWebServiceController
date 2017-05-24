//
//  MockDeserializer.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

@testable import WebServiceController

class MockDeserializer: JSONDeserializing {
    var dataToJSONCalled = false

    func dataToJSON(_ data: Data?, completion: @escaping JSONDeserializeCompletion) {
        dataToJSONCalled = true
        completion(nil, nil)
    }
}
