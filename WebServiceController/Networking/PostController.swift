//
//  PostController.swift
//  WebServiceController
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class PostController: NSObject {
    func getPosts(completion: @escaping ([Post]?, Error?) -> ()) {
        let endpoint = "posts"

        WebServiceController.sharedInstance.get(endpoint) { (objects, error) in
            guard let objects = objects as? [[String : Any]] else {
                completion(nil, error)
                return
            }

            let posts = objects.map { Post(dictionary: $0) }
            completion(posts, error)
        }
    }
}
