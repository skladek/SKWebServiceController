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

    var body: String
    let id: Int?
    var title: String
    let userId: Int?

    init() {
        self.body = ""
        self.id = nil
        self.title = ""
        self.userId = nil
    }

    init(dictionary: [String : Any]) {
        self.body = dictionary[DictionaryKeys.body] as? String ?? ""
        self.id = dictionary[DictionaryKeys.id] as? Int
        self.title = dictionary[DictionaryKeys.title] as? String ?? ""
        self.userId = dictionary[DictionaryKeys.userId] as? Int
    }
}
