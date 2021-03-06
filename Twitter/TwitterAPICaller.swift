//
//  APIManager.swift
//  Twitter
//
//  Created by Dan on 1/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterAPICaller: BDBOAuth1SessionManager {    
    static let client = TwitterAPICaller(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "uFTmFW66AAMEUwx3rZlZDMSCf", consumerSecret: "LtlxIoQpBvHcqjpSMIA9Gs2E9wCJbr7xkx9EpSdBYoNedaZUgh")
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterAPICaller.client?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            self.loginSuccess?()
        }, failure: { (error: Error!) in
            self.loginFailure?(error)
        })
    }
    
    func login(url: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        TwitterAPICaller.client?.deauthorize()
        TwitterAPICaller.client?.fetchRequestToken(withPath: url, method: "GET", callbackURL: URL(string: "alamoTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            UIApplication.shared.open(url)
        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }
    func logout (){
        deauthorize()
    }
    
    func getDictionaryRequest(url: String, parameters: [String:Any], success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()){
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(response as! NSDictionary)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getDictionariesRequest(url: String, parameters: [String:Any], success: @escaping ([NSDictionary]) -> (), failure: @escaping (Error) -> ()){
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(response as! [NSDictionary])
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    func postRequest(url: String, parameters: [Any], success: @escaping () -> (), failure: @escaping (Error) -> ()){
        TwitterAPICaller.client?.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func fetchUserTimeline(for viewController: UIViewController, count: Int, _ completion: @escaping ([Post]) -> Void) {
        var posts = [Post]()
        let timelineURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        self.getDictionariesRequest(url: timelineURL, parameters: ["count": count], success: { (postDictionaries) in
            guard let postDictionaries = postDictionaries as? [[String: Any]] else {
                AlertControllerHelper.presentAlert(for: viewController, withTitle: "Error", withMessage: "Error parsing post data")
                return
            }
            for postDictionary in postDictionaries {
                guard let post = Post(postDictionary: postDictionary) else {
                    AlertControllerHelper.presentAlert(for: viewController, withTitle: "Error", withMessage: "Error parsing post data")
                    return
                }
                posts.append(post)
            }
            
            let dispatchGroup = DispatchGroup()
            
            for post in posts {
                dispatchGroup.enter()
                _ = post.posterImage
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
            
        }, failure: { (error) in
            AlertControllerHelper.presentAlert(for: viewController, withTitle: "Error", withMessage: error.localizedDescription)
        })
    }
    
    func postTweet(withText tweetString: String, completion: @escaping (_ success: Bool, _ errorString: String?) -> ()) {
        let url = "https://api.twitter.com/1.1/statuses/update.json"
        self.post(url, parameters: ["status": tweetString], progress: nil, success: { (session, response) in
            completion(true, nil)
        }) { (session, error) in
            completion(false, error.localizedDescription)
        }
    }
    
    
    func setTweetFavourite(withID id: String, postState isFavourited: Bool, success: @escaping (_ success: Bool, _ errorString: String?) -> ()) {
        let url = isFavourited ? "https://api.twitter.com/1.1/favorites/destroy.json" : "https://api.twitter.com/1.1/favorites/create.json"
        self.post(url, parameters: ["id": id], progress: nil, success: { (task, response) in
            success(true, nil)
        }) { (task, error) in
            success(false, error.localizedDescription)
        }
    }
    
    
    func setRetweeted(withID id: String, postState isRetweeted: Bool, success: @escaping (_ success: Bool, _ errorString: String?) -> ()) {
        let url = isRetweeted ? "https://api.twitter.com/1.1/statuses/unretweet/\(id).json" : "https://api.twitter.com/1.1/statuses/retweet/\(id).json"
        self.post(url, parameters: ["id": id], progress: nil, success: { (task, response) in
            success(true, nil)
        }) { (task, error) in
            success(false, error.localizedDescription)
        }
    }
    
}
