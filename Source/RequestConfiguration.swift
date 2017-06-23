//
//  RequestConfiguration.swift
//  SKWebServiceController
//
//  Created by Sean on 6/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

public class RequestConfiguration {
    let additionalHTTPHeaders: [AnyHashable : Any]?
    let queryParameters: [AnyHashable : Any]

    init(additionalHTTPHeaders: [AnyHashable : Any]? = nil, queryParameters: [AnyHashable : Any] = [:]) {
        self.additionalHTTPHeaders = additionalHTTPHeaders
        self.queryParameters = queryParameters
    }
}
