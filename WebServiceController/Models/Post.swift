//
//  Post.swift
//  WebServiceController
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

struct Post {
    struct DictionaryKeys {
        static let body = "body"
        static let id = "id"
        static let title = "title"
        static let userId = "userId"
    }

    let body: String
    let id: Int
    let title: String
    let userId: Int

    init(dictionary: [String : Any]) {
        self.body = dictionary[DictionaryKeys.body] as? String ?? ""
        self.id = dictionary[DictionaryKeys.id] as? Int ?? Int.min
        self.title = dictionary[DictionaryKeys.title] as? String ?? ""
        self.userId = dictionary[DictionaryKeys.userId] as? Int ?? Int.min
    }
}
