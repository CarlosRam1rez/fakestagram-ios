
import UIKit

@IBDesignable

class PostAuthorView: UIView {
    var author: Author? {
        didSet { updateView() }
    }
    
    private let avatarView: SVGView = {
        let svg = SVGView()
        svg.translatesAutoresizingMaskIntoConstraints = false
        return svg
    }()
    private let nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Lorem Ipsum"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = .clear
        addSubview(avatarView)
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            avatarView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 52),
            avatarView.heightAnchor.constraint(equalToConstant: 52)
            ])
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 26
        
        addSubview(nameLbl)
        NSLayoutConstraint.activate([
            nameLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLbl.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 15),
            nameLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            nameLbl.heightAnchor.constraint(equalToConstant: 32)
            ])
    }
    
    private func updateView() {
        guard let author = self.author else { return }
        nameLbl.text = author.name
        avatarView.loadContent(from: author.avatarUrl())
    }
}
