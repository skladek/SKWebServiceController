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

        WebServiceController.sharedInstance.get(endpoint) { (objects, response, error) in
            guard let objects = objects as? [[String : Any]] else {
                completion(nil, error)
                return
            }

            let posts = objects.map { Post(dictionary: $0) }
            completion(posts, error)
        }
    }

    func uploadNew(_ post: Post, completion: @escaping (Error?) -> ()) {
        let endpoint = "posts"

        WebServiceController.sharedInstance.post(endpoint, json: post.toJSON()) { (objects, response, error) in
            completion(error)
        }
    }
}
