//
//  PostViewModel.swift
//  WebServiceController
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class PostViewModel: NSObject {
    private let post: Post

    init(post: Post) {
        self.post = post
    }

    func body() -> String {
        return post.body
    }

    func title() -> String {
        return post.title
    }
}
