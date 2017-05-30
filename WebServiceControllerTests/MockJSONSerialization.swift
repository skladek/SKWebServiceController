//
//  MockJSONSerialization.swift
//  WebServiceController
//
//  Created by Sean on 5/30/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

class MockJSONSerialization: JSONSerialization {
    override class func data(withJSONObject obj: Any, options opt: JSONSerialization.WritingOptions = []) throws -> Data {
        let error = NSError(domain: "test.domain", code: 2345, userInfo: nil)

        throw error
    }
}
