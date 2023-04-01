//
//  Task.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import Foundation
import Alamofire

struct Task: Codable {
    let taskID: String
    let taskDescription: String
    let taskAward: String?
    let petID: String
}

struct TodayTask {
    var taskID: String
    var isFinished: Bool
}



func GetDailyTasks(_ petID: String, completion: @escaping ([Task]?) -> Void){
    AF.request("http://123.249.97.150:8008/getTaskBySeed.php?petID="+petID).responseJSON { response in
        switch response.result {
        case .success(let data):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let decoder = JSONDecoder()
                let tasks = try decoder.decode([Task].self, from: jsonData)
                completion(tasks)
                
            } catch {
                print("Error decoding JSON: \(error)")
                completion([])
            }
        case .failure(let error):
            print("Error retrieving data: \(error)")
            completion([])
        }
    
    }
    
}

