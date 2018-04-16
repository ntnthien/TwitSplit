//
//  TweetTableViewCell.swift
//  TwitSplit
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(item: Tweet) {
        self.contentLabel.text = item.content
        self.titleLabel.text = item.user.name
    }
}
