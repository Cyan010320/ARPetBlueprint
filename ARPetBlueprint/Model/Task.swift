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

func getDailyTasks(_ petID: String, completion: @escaping ([Task]?) -> Void){
    //print("调用tasks")
    
    AF.request("http://123.249.97.150:8008/getTask.php?petID="+petID).responseJSON { response in
        switch response.result {
        case .success(let data):
            do {
                print("???")
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

