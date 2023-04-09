//
//  global.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/4/1.
//

import Foundation
import UIKit
import RealityKit

//两个bool表示三种状态：10=完成未领取，11=完成领取，00/01=未完成
var isTaskFinished: [Bool] = Array(repeating: false, count: 4)
var isRewardReceived: [Bool] = Array(repeating: true, count: 4)  //已领取=不能领取

var isCameraNow: Bool = true
var isBackLenNow: Bool = true

var todayTask: [TodayTask] = []     //这个暂时没用
public let postsPerPage: Int = 20
let dailyTaskNumber = 4
var dailyTasks: [Task] = []


func SetTaskToFinish(_ taskID: TaskType){
    for at in 0..<4{
        if String(taskID.rawValue) == dailyTasks[at].taskID{
            isTaskFinished[at] = true
            isRewardReceived[at] = false
            
            if dailyTasks[at].foodOrToy == "F" {
                var isInBag = false
                for i in 0..<MainViewController.userFoods.count {
                    let dailyTask = dailyTasks[at]
                    if dailyTask.awardID == MainViewController.userFoods[i].foodID {
                        let originAmont = Int(MainViewController.userFoods[i].foodAmount)!
                        let addAmont = Int(dailyTask.awardAmount)!
                        MainViewController.userFoods[i].foodAmount = String(originAmont + addAmont)
                        isInBag = true
                        break
                    }
                    
                }
                if !isInBag{
                    let foodName = extractNameAndAmount(from: dailyTasks[at].taskDescription)
                    let food = Food(foodID: dailyTasks[at].awardID, foodAmount: dailyTasks[at].awardAmount, foodName: foodName!.0)
                    MainViewController.userFoods.append(food)
                }
                
            }
            else if dailyTasks[at].foodOrToy == "T"{
                var isInBag = false
                for i in 0..<MainViewController.userToys.count {
                    let dailyTask = dailyTasks[at]
                    if dailyTask.awardID == MainViewController.userToys[i].toyID {
                        let originAmont = Int(MainViewController.userToys[i].toyAmount)!
                        let addAmont = Int(dailyTask.awardAmount)!
                        MainViewController.userToys[i].toyAmount = String(originAmont + addAmont)
                        isInBag = true
                        break
                    }
                    
                }
                if !isInBag{
                    //let toyName = extractNameAndAmount(from: dailyTasks[at].taskDescription)
                    let toyName = ("球", 2)
                    let toy = Toy(toyID: dailyTasks[at].awardID, toyAmount: dailyTasks[at].awardAmount, toyName: toyName.0)
                    MainViewController.userToys.append(toy)
                }
            }
        }
    }
    
}


func loadImage(from urlString: String, scale: CGFloat = 1.0, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        
        DispatchQueue.main.async {
            let image = UIImage(data: data, scale: scale)
            completion(image)
        }
    }.resume()
}

func extractNameAndAmount(from string: String) -> (name: String, amount: Int)? {
    guard let rangeOfX = string.range(of: "x") else {
        // If "x" is not found in the string, return nil
        return nil
    }
    
    let name = String(string[..<rangeOfX.lowerBound]).trimmingCharacters(in: .whitespaces)
    let amountString = String(string[rangeOfX.upperBound...])
    guard let amount = Int(amountString) else {
        // If the string after "x" cannot be converted to an integer, return nil
        return nil
    }
    
    return (name, amount)
}


