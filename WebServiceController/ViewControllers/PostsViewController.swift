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

        getPosts()
    }

    func getPosts() {
        postController.getPosts { [weak self] (posts, error) in
            if let error = error {
                print(error)
                return
            }

            guard let posts = posts else {
                return
            }

            self?.dataSource?.objects = [posts]
            self?.tableView.reloadData()
        }
    }
}
