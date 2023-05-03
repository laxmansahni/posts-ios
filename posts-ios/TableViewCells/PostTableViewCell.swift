//
//  PostTableViewCell.swift
//  posts-ios
//
//  Created by Laxman on 03/05/23.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var postIdLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    
    var post : Post? {
        didSet {
            postIdLabel.text = String(describing: post?.id)
            postTitleLabel.text = post?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
