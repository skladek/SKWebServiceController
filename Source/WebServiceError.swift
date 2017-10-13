import UIKit

class WebServiceError: NSError {

    // MARK: Class Types

    enum Code: Int {
        case unknown = -1
        case invalidURL
        case noData
        case invalidData
    }

    // MARK: Static Variables

    static let errorDomain = Bundle.main.bundleIdentifier ?? ""

    // MARK: Init Methods

    init(code: Code, message: String?) {
        var localizedDescription = message

        if code == .unknown && message == nil {
            localizedDescription = "An unknown error occurred."
        }

        var userInfo: [String: Any]? = nil
        if let message = localizedDescription {
            userInfo = [NSLocalizedDescriptionKey: message]
        }

        super.init(domain: WebServiceError.errorDomain, code: code.rawValue, userInfo: userInfo)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
