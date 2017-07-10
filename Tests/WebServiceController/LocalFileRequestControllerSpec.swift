import Foundation
import Nimble
import Quick

@testable import SKWebServiceController

class LocalFileRequestControllerSpec: QuickSpec {
    override func spec() {
        describe("LocalFileRequestController") {
            var unitUnderTest: LocalFileRequestController!

            beforeEach {
                let bundle = Bundle(for: type(of: self))
                unitUnderTest = LocalFileRequestController(bundle: bundle)
            }

            context("getDataFromURL(_:completion:)") {
                it("Should return an error through the completion block if the URL is invalid.") {
                    let url = URL(string: "https://invalidURL.example.com")!
                    unitUnderTest.getDataFromURL(url, completion: { (_, _, error) in
                        expect(error).toNot(beNil())
                    })
                }

                it("Should return data through the completion block if a file is found at the provided URL") {
                    let bundle = Bundle(for: type(of: self))
                    let path = bundle.path(forResource: "posts", ofType: ".json")!
                    let pathWithScheme = "file://\(path)"
                    let url = URL(string: pathWithScheme)!

                    unitUnderTest.getDataFromURL(url, completion: { (data, _, error) in
                        expect(data).toNot(beNil())
                    })
                }
            }

            context("getFileURLFromRequest(_:completion:)") {
                it("Should return nil if a file cannot be found with the last path component") {
                    let url = URL(string: "https://example.com/invalidLastPathComponent")!
                    let request = URLRequest(url: url)
                    let bundle = Bundle(for: type(of: self))

                    let result = unitUnderTest.getFileURLFromRequest(request, completion: { (_, _, _) in })

                    expect(result).to(beNil())
                }

                it("Should return an error through the completion if a file cannot be found with the last path component") {
                    let url = URL(string: "https://example.com/invalidLastPathComponent")!
                    let request = URLRequest(url: url)

                    let _ = unitUnderTest.getFileURLFromRequest(request, completion: { (_, _, error) in
                        expect(error).toNot(beNil())
                    })
                }

                it("Should return a URL if the file is found with the last path component") {
                    let url = URL(string: "https://example.com/posts")!
                    let request = URLRequest(url: url)

                    let result = unitUnderTest.getFileURLFromRequest(request, completion: { (_, _, _) in })
                    expect(result).toNot(beNil())
                }
            }

            context("getFileWithRequest(_:completion:)") {
                it("Should return data through the completion for a valid file name") {
                    let url = URL(string: "https://example.com/posts")!
                    let request = URLRequest(url: url)

                    unitUnderTest.getFileWithRequest(request, completion: { (data, _, _) in
                        expect(data).toNot(beNil())
                    })
                }
            }
        }
    }
}
