//
//  WebServiceControllerTests.swift
//  WebServiceControllerTests
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
        describe("TableViewDataSource") {
            context("null") {

                it("Should pass") {
                    expect(1).to(equal(1))
                }
            }
        }
    }
}
