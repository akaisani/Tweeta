//
//  Post.swift
//  Twitter
//
//  Created by Abid Amirali on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit


class Post {
    let poster: String
    let posterID: String
    let content: String
    let retweetCount: String
    let favouriteCount: String
    let postDate: String
    private let imageURL: String
    private var cachedImage: UIImage?
    
    init(poster: String, posterID: String, content: String, postDate: String, retweetCount: Int, favouriteCount: Int, imageURL: String) {
        self.poster = poster
        self.posterID = posterID
        self.content = content
        self.postDate = postDate
        self.retweetCount = String(retweetCount)
        self.favouriteCount = String(favouriteCount)
        self.imageURL = imageURL
    }
    
    var posterImage: UIImage? {
        if let image = self.cachedImage {
            return image
        } else {
            guard let url = URL(string: imageURL) else {return nil}
            let data = try! Data(contentsOf: url)
            self.cachedImage = UIImage(data: data)
            return self.cachedImage
        }
    }
    
    
    
    convenience init?(postDictionary: [String: Any]) {
        guard let retweetCount = postDictionary["retweet_count"] as? Int, let postDate = postDictionary["created_at"] as? String, let content = postDictionary["text"] as? String, let favouriteCount = postDictionary["favorite_count"] as? Int else {
            return nil
        }
        guard let userDictionary = postDictionary["user"] as? [String: Any] else {
            return nil
        }
        guard let poster = userDictionary["name"] as? String, let posterID = userDictionary["screen_name"] as? String, let posterImageURL = userDictionary["profile_image_url_https"] as? String else {
            return nil
        }
        
        self.init(poster: poster, posterID: posterID, content: content, postDate: postDate, retweetCount: retweetCount, favouriteCount: favouriteCount, imageURL: posterImageURL)
    }
    
    
}
