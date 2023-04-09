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
    case 伸懒腰 = 0, 趴着, 坐着伸懒腰, 喝水, 吃东西, 什么都不做, 向左看一眼, 趴下伸懒腰, 短跳, 跳下去, 着陆, 助跑大跳, 先走后跳, 蹦高, 蹦更高, 趴下, 长待机起来, 左转180, 右转180, 左转90, 右转90, 左转45, 右转45, 大跳, 左跃, 右跃, 跳跃收尾, 坐下, 坐着待机起身, 坐下左右看, 坐后躺, 躺后起身, 坐后舔手, 趴后躺, 向左走, 向右走
}


let FrameFor: [PetAnimation : (Double, Double)] =
    [
        PetAnimation.伸懒腰: (1, 61),                  //直->直
        PetAnimation.趴着: (62, 112),                 //趴->趴
        PetAnimation.坐着伸懒腰: (113, 173),             //坐->坐
        PetAnimation.喝水: (174, 274),                //直->直
        PetAnimation.吃东西: (275, 376),               //直->直
        PetAnimation.什么都不做: (377, 510),             //直->直
        PetAnimation.向左看一眼: (511, 577),             //直->直
        PetAnimation.趴下伸懒腰: (578, 678),             //直->直
        PetAnimation.短跳: (679, 714),
        PetAnimation.跳下去: (715, 745),
        PetAnimation.着陆: (768, 782),
        PetAnimation.助跑大跳: (783, 818),
        PetAnimation.先走后跳: (819, 860),
        PetAnimation.蹦高: (861, 896),
        PetAnimation.蹦更高: (897, 944),
        PetAnimation.趴下: (945, 972),                //直->趴
        PetAnimation.长待机起来: (973, 1095),        //趴->直
        PetAnimation.左转180: (1096, 1140),
        PetAnimation.右转180: (1141, 1185),
        PetAnimation.左转90: (1186, 1211),
        PetAnimation.右转90: (1212, 1237),
        PetAnimation.左转45: (1238, 1254),
        PetAnimation.右转45: (1255, 1271),
        PetAnimation.大跳: (1272, 1286),
        PetAnimation.左跃: (1287, 1301),
        PetAnimation.右跃: (1302, 1316),
        PetAnimation.跳跃收尾: (1317, 1337),
        PetAnimation.坐下: (1338, 1359),              //直->坐
        PetAnimation.坐着待机起身: (1360, 1470),           //坐->直
        PetAnimation.坐下左右看: (1479, 1580),             //坐->坐
        PetAnimation.坐后躺: (1581, 1605),                 //坐->躺
        PetAnimation.躺后起身: (1606, 1630),                //躺->坐
        PetAnimation.坐后舔手: (1631, 1731),                //坐->坐
        PetAnimation.趴后躺: (1732, 2034),                 //躺->躺
        PetAnimation.向左走: (2035, 2059),
        PetAnimation.向右走: (2060, 2084)
    ]


public func getAnimationStartAndEndTime(_ animationType: PetAnimation) -> (Double, Double) {
    let frameInterval = FrameFor[animationType]
    let startFrame = frameInterval!.0
    let endFrame = frameInterval!.1
    let startTime = startFrame / 24 + 0.02
    let endTime = endFrame / 24 - 0.02
    return (startTime, endTime)
}



extension SCNNode{
    func switchAnimation(to petAnimation: PetAnimation){
        //1.获取模型，暂停当前动画
        
        
        
        //2.找到新动画
        
        
        //3.切换过去
        
    }
    
    
    
}
