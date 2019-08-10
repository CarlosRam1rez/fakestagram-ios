import UIKit

class PostDetailViewController: UIViewController {
    public var post: Post!
    
    @IBOutlet weak var authorView: PostAuthorView!
    @IBOutlet weak var imgView: UIScrollView!
    @IBOutlet weak var titleLbl: UITextView!
    @IBOutlet weak var likeCounterLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
