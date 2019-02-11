//
//  HomeViewController.swift
//  Twitter
//
//  Created by Abid Amirali on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import DateToolsSwift

class HomeViewController: UIViewController {

    
    @IBOutlet weak var postsTableView: UITableView!
    var posts: [Post] = [Post]()
    var activityIndicator: UIActivityIndicatorView!

    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeViewController.getTimelinePosts(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.blue
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // ui activity indicator
        self.startSpinner()
        
        // adding uirefreshcontrol
        self.postsTableView.addSubview(self.refreshControl)
        
        // gettings posts
        getTimelinePosts()
    }
    
    @objc func getTimelinePosts(_ refreshControl: UIRefreshControl? = nil) {
        let count = refreshControl != nil ? 20 : self.posts.count + 20
        TwitterAPICaller.client?.fetchUserTimeline(for: self, count: count, { (posts) in
            self.posts = posts
            DispatchQueue.main.async {
                self.postsTableView.reloadData()
                self.refreshControl.endRefreshing()
                self.stopSpinner()
            }
        })
    }
    
    
    @IBAction func didPressLogoutButton(_ sender: UIBarButtonItem) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.setValue(false, forKey: "isLoggedIn")
        self.performSegue(withIdentifier: "userLoggedOut", sender: self)
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {}
    
    func configureCell(_ cell: PostCell, with post: Post) {
        cell.favouriteCountLabel.text = post.favouriteCountLabel
        var image = post.favourited ? UIImage(named: "favor-icon-red") : UIImage(named: "favor-icon")
        cell.favouritedButton.setImage(image, for: UIControl.State.normal)
        
        cell.retweetCountLabel.text = post.retweetCountLabel
        image = post.retweeted ? UIImage(named: "retweet-icon-green") : UIImage(named: "retweet-icon")
        cell.retweetButton.setImage(image, for: UIControl.State.normal)
    }
    
    // MARK: - UIActivityIndicator Setup
    func startSpinner() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        let navBarColor = self.navigationController?.navigationBar.tintColor
        activityIndicator.color = navBarColor!
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopSpinner() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }

}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        let post = self.posts[indexPath.row]
        cell.delegate = self
        cell.posterNameLabel.text = post.poster
        cell.posterIDLabel.text = post.posterID
        cell.postDataLabel.text = DateHelper.timeSincePost(for: post.postDate)
        cell.postContentLabel.text = post.content
        cell.posterProfileImageView.image = post.posterImage
        let navBarColor = self.navigationController?.navigationBar.tintColor.cgColor
        cell.cellColor = navBarColor
        configureCell(cell, with: post)
        return cell
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 10 == self.posts.count {self.getTimelinePosts()}
    }
}

extension HomeViewController: PostCellDelegate {
    func didTapFavouriteButton(_ favouriteButton: UIButton, on cell: PostCell) {
        guard let indexPath = self.postsTableView.indexPath(for: cell) else {return}
        let post = self.posts[indexPath.row]
        TwitterAPICaller.client?.setTweetFavourite(withID: post.id, postState: post.favourited, success: { (success, errorString) in
            if !success {
                AlertControllerHelper.presentAlert(for: self, withTitle: "Error!", withMessage: errorString!)
                return
            }
            post.favourited = !post.favourited
            let postUpdate = post.favourited ? +1 : -1
            post.favouriteCount = post.favouriteCount + postUpdate
            self.configureCell(cell, with: post)
        })
    }
    
    func didTapRetweetButton(_ favouriteButton: UIButton, on cell: PostCell) {
        guard let indexPath = self.postsTableView.indexPath(for: cell) else {return}
        let post = self.posts[indexPath.row]
        TwitterAPICaller.client?.setRetweeted(withID: post.id, postState: post.retweeted, success: { (success, errorString) in
            if !success {
                AlertControllerHelper.presentAlert(for: self, withTitle: "Error!", withMessage: errorString!)
                return
            }
            post.retweeted = !post.retweeted
            let postUpdate = post.retweeted ? +1 : -1
            post.retweetCount = post.retweetCount + postUpdate
            self.configureCell(cell, with: post)
        })
    }
    
}
