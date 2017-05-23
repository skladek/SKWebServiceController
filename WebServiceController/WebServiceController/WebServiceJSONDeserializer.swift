//
//  WebServiceJSONDeserializer.swift
//  WebServiceController
//
//  Created by Sean on 5/23/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import Foundation

class WebServiceJSONDeserializer: JSONDeserializing {
    func dataToJSON(_ data: Data?, completion: @escaping WebServiceController.RequestCompletion) {
        guard let data = data else {
            let error = WebServiceError(code: .noData, message: "The server returned without error and without data.")
            completion(nil, error)
            return
        }

        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            completion(jsonData, nil)
        } catch {
            completion(nil, error)
        }
    }
}
