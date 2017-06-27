import Foundation
import Nimble
import Quick

@testable import SKWebServiceController

class DictionarySpec: QuickSpec {
    override func spec() {
        var unitUnderTest: Dictionary<AnyHashable, Any>!
        describe("Dictionary") {
            context("stringValue(_:)") {
                beforeEach {
                    unitUnderTest = [:]
                }

                it("Should return 1 if the input value is true") {
                    expect(unitUnderTest.stringValue(true)).to(equal("1"))
                }

                it("Should return 0 if the input value is true") {
                    expect(unitUnderTest.stringValue(false)).to(equal("0"))
                }

                it("Should return a string representation of a float") {
                    expect(unitUnderTest.stringValue(1.234)).to(equal("1.234"))
                }

                it("Should return a string representation of an Int") {
                    expect(unitUnderTest.stringValue(1234)).to(equal("1234"))
                }

                it("Should return the input string") {
                    expect(unitUnderTest.stringValue("Test String")).to(equal("Test String"))
                }
            }
        }
    }
}
