//
//  JSONHandling.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

typealias ConvertedJSON = (object: Any?, error: Error?)

protocol JSONHandling {
    func dataToJSON(_ data: Data?) -> ConvertedJSON
    func jsonToData(_ jsonObject: Any?) -> ConvertedJSON
}
