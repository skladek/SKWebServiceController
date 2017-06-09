//
//  MyWebServiceController.swift
//  WebServiceController
//
//  Created by Sean on 6/1/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import SKWebServiceController
import UIKit

class MyWebServiceController: WebServiceController {
    static let sharedInstance = MyWebServiceController()

    init() {
        super.init(baseURL: "https://jsonplaceholder.typicode.com/")
    }
}