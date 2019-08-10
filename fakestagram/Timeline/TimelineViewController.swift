//
//  TimelineViewController.swift
//  fakestagram
//
//  Created by LuisE on 3/16/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    @IBOutlet weak var postsCollectionView: UICollectionView!
    let client = TimelineClient()
    let refreshControl = UIRefreshControl()
    var pageOffset = 1
    var loadingPage = false
    var lastPage = false
    
    var posts: [Post] = []
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.gray
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(didLikePost(_:)), name: .didLikePost, object: nil)
        refreshControl.addTarget(self, action: #selector(self.reloadData), for: UIControl.Event.valueChanged)
        
        loadingIndicator.center = self.view.center
        loadingIndicator.startAnimating()
        self.view.addSubview(loadingIndicator)
        
        client.show { [weak self] data in
            self?.posts = data
            self?.loadingIndicator.stopAnimating()
            self?.postsCollectionView.reloadData()
        }
    }

    private func configCollectionView() {
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        postsCollectionView.prefetchDataSource = self
        let postCollectionViewCellXib = UINib(nibName: String(describing: PostCollectionViewCell.self), bundle: nil)
        postsCollectionView.register(postCollectionViewCellXib, forCellWithReuseIdentifier: PostCollectionViewCell.reuseIdentifier)
        postsCollectionView.addSubview(refreshControl)
    }
    
    @objc func reloadData() {
        pageOffset = 1
        client.show { [weak self] data in
            self?.posts = data
            sleep(1)
            self?.refreshControl.endRefreshing()
            self?.postsCollectionView.reloadData()
        }
    }
    
    @objc func didLikePost(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let row = userInfo["row"] as? Int,
            let data = userInfo["post"] as? Data,
            let json = try? JSONDecoder().decode(Post.self, from: data) else { return }
        posts[row] = json
    }
    
    func loadNextPage() {
        if lastPage { return }
        loadingPage = true
        pageOffset += 1
        client.show(page: pageOffset) { [weak self] posts in
            self?.lastPage = posts.count < 25
            self?.posts.append(contentsOf: posts)
            self?.loadingPage = false
            self?.postsCollectionView.reloadData()
        }
    }
    
}

extension TimelineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.postsCollectionView.frame.width, height: 600)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuseIdentifier, for: indexPath) as! PostCollectionViewCell
        cell.post = posts[indexPath.row]
        cell.row = indexPath.row
        return cell
    }
}

extension TimelineViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if loadingPage { return }
        guard let indexPath = indexPaths.last else { return }
        let upperLimit = posts.count - 5
        if indexPath.row > upperLimit {
            loadNextPage()
        }
    }
}

