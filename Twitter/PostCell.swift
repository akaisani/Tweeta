//
//  PostCell.swift
//  Twitter
//
//  Created by Abid Amirali on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

protocol PostCellDelegate {
    func didTapFavouriteButton(_ favouriteButton: UIButton, on cell: PostCell);
    func didTapRetweetButton(_ favouriteButton: UIButton, on cell: PostCell);
}

class PostCell: UITableViewCell {

    @IBOutlet weak var posterNameLabel: UILabel!
    @IBOutlet weak var posterProfileImageView: UIImageView!
    @IBOutlet weak var posterIDLabel: UILabel!
    @IBOutlet weak var postDataLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favouriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favouritedButton: UIButton!
    var cellColor: CGColor!
    var delegate: PostCellDelegate!
    
    @IBOutlet weak var tweetImageView: UIImageView!
    override func draw(_ rect: CGRect) {
        self.posterProfileImageView.layer.borderColor = cellColor ?? UIColor.white.cgColor
        self.posterProfileImageView.layer.cornerRadius = self.posterProfileImageView.frame.height / 2
        self.posterProfileImageView.clipsToBounds = true
        self.posterProfileImageView.layer.borderWidth = 3
    }
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        delegate.didTapFavouriteButton(sender, on: self)
    }
    
    
    @IBAction func retweetButtonPressed(_ sender: UIButton) {
        delegate.didTapRetweetButton(sender, on: self)
    }
    
    
    
}
