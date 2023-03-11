//
//  TaskTVC.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import UIKit

class TaskTVC: UITableViewCell {
    @IBOutlet weak var taskAward: UILabel!
    
    @IBOutlet weak var taskDescription: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
