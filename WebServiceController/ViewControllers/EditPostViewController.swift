//
//  EditPostViewController.swift
//  WebServiceController
//
//  Created by Sean on 5/24/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController {

    @IBOutlet weak var bodyTextField: UITextField!

    @IBOutlet weak var titleTextField: UITextField!

    fileprivate let newPost: Bool

    fileprivate let post: Post

    init(post: Post?) {
        self.newPost = (post == nil)
        self.post = post ?? Post()

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createNewPost() {

    }

    func updatePost() {

    }

    @IBAction func submitTapped() {
        if newPost {
            createNewPost()
        } else {
            updatePost()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bodyTextField.text = post.body
        titleTextField.text = post.title
    }
}
