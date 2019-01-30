//
//  PostCell.swift
//  Twitter
//
//  Created by Abid Amirali on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var posterNameLabel: UILabel!
    @IBOutlet weak var posterProfileImageView: UIImageView!
    @IBOutlet weak var posterIDLabel: UILabel!
    @IBOutlet weak var postDataLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favouriteCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
