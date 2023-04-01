//
//  global.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/4/1.
//

import Foundation

//两个bool表示三种状态：10=完成未领取，11=完成领取，00/01=未完成
var isTaskFinished: [Bool] = Array(repeating: false, count: 4)
var isRewardReceived: [Bool] = Array(repeating: true, count: 4)  //已领取=不能领取



var todayTask: [TodayTask] = []     //这个暂时没用
public let postsPerPage: Int = 20
let dailyTaskNumber = 4
var dailyTasks: [Task] = []

func SetTaskToFinish(_ taskID: TaskType){
    for at in 0..<4{
        if String(taskID.rawValue) == dailyTasks[at].taskID{
            isTaskFinished[at] = true
        }
    }
}
