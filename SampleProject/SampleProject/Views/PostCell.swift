import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var body: UILabel!

    @IBOutlet weak var title: UILabel!

    func setViewModel(viewModel: PostViewModel) {
        body.text = viewModel.body()
        title.text = viewModel.title()
    }
}
