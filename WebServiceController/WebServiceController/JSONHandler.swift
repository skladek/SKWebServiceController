//
//  JSONHandler.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

class JSONHandler: JSONHandling {
    func dataToJSON(_ data: Data?) -> ConvertedJSON {
        guard let data = data else {
            let error = WebServiceError(code: .noData, message: "The server returned without error and without data.")
            return (nil, error)
        }

        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return (jsonData, nil)
        } catch {
            return (nil, error)
        }
    }
}
