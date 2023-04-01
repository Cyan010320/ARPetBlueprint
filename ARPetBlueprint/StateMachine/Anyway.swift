//
//  Anyway.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/27.
//

import Foundation
import ARKit

//拿PetAnimation随机访问TimeFor
public enum PetAnimation: Int{
    case idle=0, lie, sit, drink, eat, jumpDown, jumpRun, jumpTrot, jumpUp, jumpUpLong, rotate180L, rotate180R, rotate90L, rotate90R, runForward, runLeft, runRight, runStop, sitIdle, sitLie, sitWash, sleep, walkForward, walkLeft, walkRight
}


let TimeFor: [(Float, Float)] =
    [
        (0, 0.5),
        (0.5, 3),
        (3, 3.8)
    //填满时间轴
    
    
    
    ]




extension SCNNode{
    func switchAnimation(to petAnimation: PetAnimation){
        //1.获取模型，暂停当前动画
        
        
        
        //2.找到新动画
        
        
        //3.切换过去
        
    }
    
    
    
}
