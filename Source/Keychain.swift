/**
 This class is adapted from https://gist.github.com/jackreichert/414623731241c95f0e20
 */

import UIKit
import Security

protocol KeychainProtocol {
    func delete(key: String)
    func load(key: String) -> Data?
    func save(key: String, data: Data)
}

/// Provides access to the system keychain
class Keychain: KeychainProtocol {

    // MARK: Static Variables

    static let authTokenKeychainKey = "AuthorizationTokenKey"

    // MARK: Class Methods

    func delete(key: String) {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key]

        SecItemDelete(query as CFDictionary)
    }

    func load(key: String) -> Data? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecReturnData as String: kCFBooleanTrue,
                                    kSecMatchLimit as String: kSecMatchLimitOne]

        var data: AnyObject?
        _ = withUnsafeMutablePointer(to: &data) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }

        return data as? Data
    }

    func save(key: String, data: Data) {
        let query: [String: AnyObject] = [kSecAttrAccount as String: key as AnyObject,
                                          kSecAttrService as String: "myServiceName" as AnyObject,
                                          kSecClass as String: kSecClassGenericPassword,
                                          kSecValueData as String: data as AnyObject
        ]

        SecItemAdd(query as CFDictionary, nil)
    }
}
