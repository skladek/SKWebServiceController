import Foundation
import Nimble
import Quick

@testable import SKWebServiceController

class WebServiceErrorSpec: QuickSpec {

    override func spec() {
        describe("WebServiceError") {
            var unitUnderTest: WebServiceError!

            context("init(code:message:)") {
                it("Should return an error with the specified code and message") {
                    let code: WebServiceError.Code = .unknown
                    let message = "testMessage"
                    unitUnderTest = WebServiceError(code: code, message: message)

                    expect(unitUnderTest.code).to(equal(WebServiceError.Code.unknown.rawValue))
                    expect(unitUnderTest.localizedDescription).to(equal(message))
                }

                it("Should use a default message if the code equals unknown and message is nil") {
                    unitUnderTest = WebServiceError(code: .unknown, message: nil)
                    expect(unitUnderTest.localizedDescription).to(equal("An unknown error occurred."))
                }

                it("Should not use a default message if the code does not equal unknown and message is nil") {
                    unitUnderTest = WebServiceError(code: .invalidURL, message: nil)
                    expect(unitUnderTest.localizedDescription).toNot(equal("An unknown error occurred."))
                }
            }

            context("init(aDecoder:)") {
                it("should return nil") {
                    expect(WebServiceError(coder: NSCoder())).to(beNil())
                }
            }
        }
    }
}
