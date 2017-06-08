//
//  ImageCell.swift
//  SampleProject
//
//  Created by Sean on 6/8/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    func loadImage() {
        let url = URL(string: "https://unsplash.it/200.png")
        guard let unwrappedUrl = url else {
            return
        }

        MyWebServiceController.sharedInstance.getImage(unwrappedUrl) { (image, response, error) in
            self.imageView.image = image
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
    }

}
