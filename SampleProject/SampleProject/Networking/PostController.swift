import UIKit

class PostController: NSObject {
    struct Endpoints {
        static let posts = "posts"
        static let postsWithId = "posts/%ld"
    }

    let webServiceController = MyWebServiceController()

    func delete(_ post: Post, completion: @escaping (Error?) -> Void) {
        guard let postId = post.identifier else {
            return
        }

        let endpoint = String(format: Endpoints.postsWithId, postId)

        webServiceController.delete(endpoint) { (_: Any?, _, error) in
            completion(error)
        }
    }

    func getPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        webServiceController.get(Endpoints.posts) { (objects: [[String: Any]]?, _, error) in
            guard let objects = objects else {
                completion(nil, error)
                return
            }

            let posts = objects.map { Post(dictionary: $0) }
            completion(posts, error)
        }
    }

    func update(_ post: Post, completion: @escaping (Error?) -> Void) {
        guard let postId = post.identifier else {
            return
        }

        let endpoint = String(format: Endpoints.postsWithId, postId)

        webServiceController.put(endpoint, json: post.toJSON(), requestConfiguration: nil) { (_: Any?, _, error) in
            completion(error)
        }
    }

    func uploadNew(_ post: Post, completion: @escaping (Error?) -> Void) {
        webServiceController.post(Endpoints.posts, json: post.toJSON()) { (_: Any?, _, error) in
            completion(error)
        }
    }
}
