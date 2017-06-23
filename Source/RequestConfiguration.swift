//
//  RequestConfiguration.swift
//  SKWebServiceController
//
//  Created by Sean on 6/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

public class RequestConfiguration {
    let queryParameters: [String : String]

    init(queryParameters: [String : String] = [:]) {
        self.queryParameters = queryParameters
    }
}
