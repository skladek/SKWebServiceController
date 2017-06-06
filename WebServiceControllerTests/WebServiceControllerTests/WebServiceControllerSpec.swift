//
//  WebServiceControllerSpec.swift
//  WebServiceController
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import WebServiceController

class WebServiceControllerSpec: QuickSpec {
    override func spec() {
        var session: MockSession!
        var unitUnderTest: WebServiceController!

        beforeEach {
            session = MockSession()
            unitUnderTest = WebServiceController(testingBaseURL: "https://jsonplaceholder.typicode.com/", defaultParameters: [:], session: session)
        }

        describe("WebServiceController") {
            context("init(baseURL:defaultParameters:)") {
            }

            context("delete(endpoint:completion:)") {
            }

            context("get(endpoint:parameters:completion:") {
            }

            context("getImage(url:completion:)") {
            }

            context("post(endpoint:parameters:json:completion:)") {
            }

            context("put(endpoint:parameters:json:completion:)") {
            }
        }
    }
}
