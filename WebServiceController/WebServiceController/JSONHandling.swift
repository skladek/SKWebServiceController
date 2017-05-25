//
//  JSONHandling.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

/// A tuple containing the converted object or an error encountered while converting.
typealias ConvertedJSON = (object: Any?, error: Error?)

protocol JSONHandling {
    func dataToJSON(_ data: Data?) -> ConvertedJSON
    func jsonToData(_ jsonObject: Any?) -> ConvertedJSON
}
