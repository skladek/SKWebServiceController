//
//  ImageRequestsViewController.swift
//  SampleProject
//
//  Created by Sean on 6/8/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class ImageRequestsViewController: UIViewController {

    static let reuseId = "ImageCellReuseId"

    @IBOutlet weak var collecitonView: UICollectionView!
    @IBOutlet weak var groupSwitch: UISwitch!

    @IBAction func switchValueChanged(sender: UISwitch) {
        MyWebServiceController.sharedInstance.groupIdenticalImageRequests = sender.isOn
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ImageCell", bundle: nil)
        collecitonView.register(nib, forCellWithReuseIdentifier: ImageRequestsViewController.reuseId)

        groupSwitch.isOn = MyWebServiceController.sharedInstance.groupIdenticalImageRequests
    }

}

extension ImageRequestsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1500
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecitonView.dequeueReusableCell(withReuseIdentifier: ImageRequestsViewController.reuseId, for: indexPath)

        if let cell = cell as? ImageCell {
            cell.loadImage()
        }

        return cell
    }
}
