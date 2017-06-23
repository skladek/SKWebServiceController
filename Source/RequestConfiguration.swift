//
//  RequestConfiguration.swift
//  SKWebServiceController
//
//  Created by Sean on 6/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

/// Provides values to configure a single request.
public class RequestConfiguration {
    let additionalHTTPHeaders: [AnyHashable : Any]?
    let queryParameters: [AnyHashable : Any]

    /// Initializes a request configuration object
    ///
    /// - Parameters:
    ///   - additionalHTTPHeaders: Additional HTTP headers to append to the request.
    ///        This will override any settings provided by the URLSessionConfiguration.
    ///   - queryParameters: Query parameters to append to the endpoint.
    public init(additionalHTTPHeaders: [AnyHashable : Any]? = nil, queryParameters: [AnyHashable : Any] = [:]) {
        self.additionalHTTPHeaders = additionalHTTPHeaders
        self.queryParameters = queryParameters
    }
}
