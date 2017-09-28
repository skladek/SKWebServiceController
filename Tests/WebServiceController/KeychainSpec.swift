import Foundation
import Nimble
import Quick

@testable import SKWebServiceController

class KeychainSpec: QuickSpec {

    override func spec() {
        describe("Keychain") {
            var data: Data!
            var key: String!
            var unitUnderTest: Keychain!

            beforeEach {
                data = "TestData".data(using: .utf8, allowLossyConversion: false)
                key = "TestKeychainKey"
                unitUnderTest = Keychain()
            }

            context("delete(key:)") {
                it("Should delete the item at the specified key") {
                    unitUnderTest.save(key: key, data: data)
                    unitUnderTest.delete(key: key)
                    let result = unitUnderTest.load(key: key)
                    expect(result).to(beNil())
                }
            }

//            context("load(key:)") {
//                it("Should return nil if there is no item at the specified key") {
//                    let result = unitUnderTest.load(key: "InvalidKey")
//                    expect(result).to(beNil())
//                }
//
//                it("Should return the item at the specified key if it exists") {
//                    unitUnderTest.save(key: key, data: data)
//                    let result = unitUnderTest.load(key: key)
//                    expect(result).to(equal(data))
//                }
//            }
//
//            context("save(key:data:)") {
//                it("Should save the data at the specified key") {
//                    unitUnderTest.save(key: key, data: data)
//                    let result = unitUnderTest.load(key: key)
//                    expect(result).to(equal(data))
//                }
//            }
        }
    }
}
