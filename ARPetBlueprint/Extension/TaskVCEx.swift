//
//  TaskVCEx.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/10.
//

import Foundation
import UIKit

extension TaskVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyTaskNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTVC", for: indexPath) as! TaskTVC
        //需要每天第一次查看时刷新，而不点进去就刷新。

        let task = dailyTasks[indexPath.row]
        let row = indexPath.row
        if isTaskFinished[row] &&  isRewardReceived[row] {
            //完成且领完奖励
            cell.taskProgress.text = "进度：1/1"
            cell.taskFinishBtn.backgroundColor = .gray
            cell.taskFinishBtn.tintColor = .blue
            cell.taskFinishBtn.setTitle("已完成", for: .normal)
            
        }
        else if isTaskFinished[row] && !isRewardReceived[row] {
            //完成且没领奖励
            cell.taskProgress.text = "进度：1/1"
            cell.taskFinishBtn.backgroundColor = .blue
            cell.taskFinishBtn.tintColor = .white
            cell.taskFinishBtn.setTitle("领取", for: .normal)
            
        }
        else{
            //未完成
            
        }
        cell.taskDescription.text = task.taskDescription
        cell.taskAward.text = "奖励：" + task.taskAward!
        //}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }

}
