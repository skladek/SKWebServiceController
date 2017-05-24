//
//  PostsViewController.swift
//  WebServiceController
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
    static let reuseId = "PostsTableViewCellReuseId"

    @IBOutlet weak var tableView: UITableView!

    var dataSource: TableViewDataSource<Post>?

    let postController = PostController()

    func getPosts() {
        postController.getPosts { [weak self] (posts, error) in
            if let error = error {
                print(error)
                return
            }

            self?.dataSource?.objects(posts)
            self?.tableView.reloadData()
        }
    }

    func newPost() {
        pushEditPostViewController(post: nil)
    }

    func pushEditPostViewController(post: Post?) {
        let editViewController = EditPostViewController(post: post)
        navigationController?.pushViewController(editViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Posts"

        let postCellNib = UINib(nibName: "PostCell", bundle: Bundle.main)
        tableView.register(postCellNib, forCellReuseIdentifier: PostsViewController.reuseId)

        dataSource = TableViewDataSource(objects: [Post](), cellReuseId: PostsViewController.reuseId, cellPresenter: { (cell, object) in
            guard let cell = cell as? PostCell else {
                return
            }

            let viewModel = PostViewModel(post: object)
            cell.setViewModel(viewModel: viewModel)
        })

        tableView.dataSource = dataSource
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getPosts))
        let newPostButton = UIBarButtonItem(title: "NEW POST", style: .plain, target: self, action: #selector(newPost))
        navigationItem.leftBarButtonItem = refreshButton
        navigationItem.rightBarButtonItem = newPostButton

        getPosts()
    }
}

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.dataSource?.object(indexPath)
        pushEditPostViewController(post: post)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
