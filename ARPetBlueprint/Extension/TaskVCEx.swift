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
        //let task = tasks![indexPath.row]
        //需要每天第一次查看时刷新，而不死点进去就刷新。
//        getDailyTasks("1") { tasks in
//            if let tasks = tasks {
//                print("indexpath.row:\(indexPath.row)")
//                let task = tasks[indexPath.row]
//                cell.taskDescription.text = task.taskDescription
//                cell.taskAward.text = "奖励：" + task.taskAward!
//            } else {
//                print("error!")
//            }
//        }
        //这是第二种
        //获取今天的第indexPath.row个任务
        let task = dailyTasks[0]
        //这是第二种
        cell.taskDescription.text = task.taskDescription
        cell.taskAward.text = "奖励：" + task.taskAward!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }

    
    
    
}
