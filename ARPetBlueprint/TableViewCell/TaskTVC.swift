//
//  TaskTVC.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import UIKit

class TaskTVC: UITableViewCell {
    @IBOutlet weak var taskAward: UILabel!
    
    @IBOutlet weak var taskProgress: UILabel!
    @IBOutlet weak var taskFinishBtn: UIButton!
    @IBOutlet weak var taskDescription: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func Click(_ sender: Any) {
        
//        if taskFinishBtn.titleLabel?.text == "领取"
        if taskFinishBtn.titleLabel?.text == "领取"{
            //1.获得奖励，告诉服务器
            
            taskFinishBtn.setTitle("已完成", for: .normal)
            taskFinishBtn.backgroundColor = .gray
            taskFinishBtn.tintColor = .blue
            taskFinishBtn.layer.cornerRadius = 5
            
        }
  
    }
    
}
