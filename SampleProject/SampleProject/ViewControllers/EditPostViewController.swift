import UIKit

class EditPostViewController: UIViewController {

    @IBOutlet weak var bodyTextField: UITextField!

    @IBOutlet weak var titleTextField: UITextField!

    fileprivate let newPost: Bool

    fileprivate let post: Post

    fileprivate let postController = PostController()

    init(post: Post?) {
        self.newPost = (post == nil)
        self.post = post ?? Post()

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createNewPost() {
        postController.uploadNew(post) { (error) in
            if let error = error {
                print(error)
            }
        }
    }

    func updatePost() {
        postController.update(post) { (error) in
            if let error = error {
                print(error)
            }
        }
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
