//
//  Food.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/18.
//

import Foundation

struct Food{
    public var foodID: String
    var foodAmount: String
    var foodName: String
}

struct UserFoodUpdate: Codable{
    var userID: String
    var foodID: String
    var foodAmount: Int
}

