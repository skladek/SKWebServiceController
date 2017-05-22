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

    var dataSource: TableViewDataSource<String>?

    var posts: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Posts"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PostsViewController.reuseId)

        posts = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
        dataSource = TableViewDataSource(objects: posts, cellReuseId: PostsViewController.reuseId, cellPresenter: { (cell, object) in
            cell.textLabel?.text = object
        })

        tableView.dataSource = dataSource
    }
}
