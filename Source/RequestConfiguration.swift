import Foundation

/// Provides values to configure a single request.
public class RequestConfiguration {

    // MARK: Internal Properties

    let additionalHTTPHeaders: [AnyHashable: Any]?
    let queryParameters: [AnyHashable: Any]

    /// Initializes a request configuration object
    ///
    /// - Parameters:
    ///   - additionalHTTPHeaders: Additional HTTP headers to append to the request. This will override
    ///        any settings provided by the URLSessionConfiguration. Supported value types are String, Number,
    ///        and Boolean. Other types will attempt to be converted, but the result is not guaranteed.
    ///   - queryParameters: Query parameters to append to the endpoint. Supported value types are String, Number,
    ///        and Boolean. Other types will attempt to be converted, but the result is not guaranteed.
    public init(additionalHTTPHeaders: [AnyHashable: Any]? = nil, queryParameters: [AnyHashable: Any] = [:]) {
        self.additionalHTTPHeaders = additionalHTTPHeaders
        self.queryParameters = queryParameters
    }
}
