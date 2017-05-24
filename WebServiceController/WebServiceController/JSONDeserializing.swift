//
//  JSONDeserializing.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

typealias JSONDeserializeCompletion = (Any?, Error?) -> ()

protocol JSONDeserializing {
    func dataToJSON(_ data: Data?, completion: @escaping JSONDeserializeCompletion)
}
