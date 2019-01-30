//
//  HomeViewController.swift
//  Twitter
//
//  Created by Abid Amirali on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var postsTableView: UITableView!
    var posts: [Post] = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
        // Do any additional setup after loading the view.
        fetchUserTimeline()
    }
    
    private func fetchUserTimeline() {
        posts = []
        let timelineURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        TwitterAPICaller.client?.getDictionariesRequest(url: timelineURL, parameters: [:], success: { (postDictionaries) in
            guard let postDictionaries = postDictionaries as? [[String: Any]] else {
                AlertControllerHelper.presentAlert(for: self, withTitle: "Error", withMessage: "Error parsing post data")
                return
            }
            for postDictionary in postDictionaries {
                guard let retweetCount = postDictionary["retweet_count"] as? Int, let postDate = postDictionary["created_at"] as? String, let content = postDictionary["text"] as? String, let favouriteCount = postDictionary["favorite_count"] as? Int else {
                    
                    AlertControllerHelper.presentAlert(for: self, withTitle: "Error", withMessage: "Error parsing post data")
                    return
                }
                guard let userDictionary = postDictionary["user"] as? [String: Any] else {
                    AlertControllerHelper.presentAlert(for: self, withTitle: "Error", withMessage: "Error parsing post data\nCould not get poster data.")
                    return
                }
                guard let poster = userDictionary["name"] as? String, let posterID = userDictionary["screen_name"] as? String, let posterImageURL = userDictionary["profile_image_url_https"] as? String else {
                    AlertControllerHelper.presentAlert(for: self, withTitle: "Error", withMessage: "Error parsing post data\nCould not get poster name or ID or image")
                    return
                }
                let post = Post(poster: poster, posterID: posterID, content: content, postDate: postDate, retweetCount: retweetCount, favouriteCount: favouriteCount, imageURL: posterImageURL)
                self.posts.append(post
                )
            }
            
            let dispatchGroup = DispatchGroup()
            
            for post in self.posts {
                dispatchGroup.enter()
                _ = post.posterImage
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                DispatchQueue.main.async {
                    // reload table view
                    self.postsTableView.reloadData()
                }
            })
            
        }, failure: { (error) in
            AlertControllerHelper.presentAlert(for: self, withTitle: "Error", withMessage: error.localizedDescription)
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
        cell.postDataLabel.text = post.postData
        cell.postContentLabel.text = post.content
        cell.retweetCountLabel.text = post.retweetCount
        cell.favouriteCountLabel.text = post.favouriteCount
        cell.posterProfileImageView.image = post.posterImage
        
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
