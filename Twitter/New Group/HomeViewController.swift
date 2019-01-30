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
        
        // adding uirefreshcontrol
        self.postsTableView.addSubview(self.refreshControl)
        
        // gettings posts
        getTimelinePosts()
    }
    
    @objc func getTimelinePosts(_ refreshControl: UIRefreshControl? = nil) {
        TwitterAPICaller.client?.fetchUserTimeline(for: self, { (posts) in
            self.posts = posts
            DispatchQueue.main.async {
                self.postsTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    @IBAction func didPressLogoutButton(_ sender: UIBarButtonItem) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.setValue(false, forKey: "isLoggedIn")
        self.performSegue(withIdentifier: "userLoggedOut", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        let post = self.posts[indexPath.row]
        
        cell.posterNameLabel.text = post.poster
        cell.posterIDLabel.text = post.posterID
        cell.postDataLabel.text = DateHelper.timeSincePost(for: post.postDate)
        cell.postContentLabel.text = post.content
        cell.retweetCountLabel.text = post.retweetCount
        cell.favouriteCountLabel.text = post.favouriteCount
        cell.posterProfileImageView.image = post.posterImage
        
        let navBarColor = self.navigationController?.navigationBar.tintColor
        cell.posterProfileImageView.layer.borderColor = navBarColor?.cgColor
        cell.posterProfileImageView.layer.cornerRadius = cell.posterProfileImageView.frame.height / 2
        cell.posterProfileImageView.clipsToBounds = true
        cell.posterProfileImageView.layer.borderWidth = 2
        
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
}
