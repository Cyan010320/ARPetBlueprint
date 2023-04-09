//
//  PostTVC.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/12.
//

import UIKit



class PostTVC: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var titleView: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postImg1: UIImageView!
    @IBOutlet weak var postImg2: UIImageView!
    @IBOutlet weak var postImg3: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
