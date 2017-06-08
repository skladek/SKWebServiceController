//
//  PostCell.swift
//  WebServiceController
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var body: UILabel!

    @IBOutlet weak var title: UILabel!

    func setViewModel(viewModel: PostViewModel) {
        body.text = viewModel.body()
        title.text = viewModel.title()
    }
}
