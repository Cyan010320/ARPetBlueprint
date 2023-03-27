//
//  SpeechRecognition.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/12.
//

import Foundation
import AVFoundation
import Speech

//实现命令的匹配

//获取用户宠物可用的指令
public func getAvailableInstructions(_ petID: pet) -> [String: Int] {
    var instructions: [String: Int] = [:]
    
    switch petID {
    case .catID:
        instructions = [
            "来": 1,
            "坐": 2,
            "转圈": 3
        ]
    case .dogID:
        break
    case .birdID:
        break
    }
    return instructions
}







