//
//  WebServiceError.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class WebServiceError: NSError {
    // MARK: Class Types

    /// Error codes to describe possible Location Services error states.
    ///
    /// - unknown: An error occurred for an unknown reason.
    /// - invalidURL: The URL could not be formed from the BaseURL and endpoint.
    enum Code: Int {
        case unknown = -1
        case invalidURL
        case noData
        case invalidData
    }

    // MARK: Static Variables

    /// The domain for errors. This should be updated to match the app Bundle Id on integration.
    static let errorDomain = Bundle.main.bundleIdentifier ?? ""

    // MARK: Init Methods

    /// Initializes an error with the error code and an optional message.
    ///
    /// - Parameters:
    ///   - code: The error code to use to describe the error
    ///   - message: A string describing the error. If nil is passed as a message and code equals unknown, a generic message is used.
    init(code: Code, message: String?) {
        var localizedDescription = message

        if code == .unknown && message == nil {
            localizedDescription = "An unknown error occurred."
        }

        var userInfo: [AnyHashable : Any]? = nil
        if let message = localizedDescription {
            userInfo = [NSLocalizedDescriptionKey : message]
        }

        super.init(domain: WebServiceError.errorDomain, code: code.rawValue, userInfo: userInfo)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
