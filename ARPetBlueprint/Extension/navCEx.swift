//
//  navCEx.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import Foundation

extension navC{
    @discardableResult func checkIfFirstLoad() -> Bool{
        //var isFirstLoad: Bool = true
        let defaults = UserDefaults.standard
//        guard defaults.object(forKey: "isFirstLoad") != nil else{
//            defaults.set(1, forKey: "isFirstLoad")
//            return true
//            //回到willAppear，切换
//        }
        if let isFirstLoad = defaults.object(forKey: "myData_IsFirstLoad") {
            print("isFirstLoad: \(isFirstLoad)")
            if isFirstLoad as! Int == 0{
                return false
            } else{
                return true
            }
        }
        defaults.set(1, forKey: "myData_IsFirstLoad")
        return true
    }
}
