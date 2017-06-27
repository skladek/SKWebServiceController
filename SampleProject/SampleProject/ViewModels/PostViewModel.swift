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
        guard let postId = post.id else {
            return post.title.capitalized
        }

        return "\(postId):" + "    " + post.title.capitalized
    }
}
