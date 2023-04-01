//
//  FoodCollectionViewCell.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/17.
//

import UIKit

protocol FeedCellDelegate: AnyObject {
    func UpdateFoodBar(for id: String)
}


class FoodCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var foodLabel: UILabel!
    var foodInCell: Food?
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var foodImage: UIImageView!
    
    var delegate: FeedCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        let touchUpInside = UITapGestureRecognizer(target: self, action: #selector(Feed))
        touchUpInside.delegate = self
        self.addGestureRecognizer(touchUpInside)
        
        // Initialization code
    }
    
    static let foodValue: [String: Float] = [
        "1": 20,
        "2": 25,
        "3": 15,
        "4": 20,
        "5": 10,
        "6": 15
    ]
    
    @objc func Feed(_ sender: UIGestureRecognizer){
        //首先，给宠物回血
        print("点击")
        //self.superview?.superview.
        
        
        //其次，更新UI
        if var number = Int(self.foodInCell!.foodAmount) {
            number -= 1
            
            let userDefaults = UserDefaults.standard
            let dictionary = userDefaults.dictionaryRepresentation()
            let filteredDictionary = dictionary.filter { $0.key.hasPrefix("myData_") }
            print(filteredDictionary)



            if number == 0 {
                let SuperView = self.superview!
                self.removeFromSuperview()
                UIView.animate(withDuration: 0.2) {
                    for view in SuperView.subviews where view.frame.origin.x > self.frame.origin.x {
                        view.frame.origin.x -= self.frame.width
                    }
                }
            }
            self.foodInCell!.foodAmount = String(number)
        }
        
        self.amountLabel.text = "x\(foodInCell!.foodAmount)"
        delegate?.UpdateFoodBar(for: self.foodInCell!.foodID)
        
        //然后，判断任务是否完成
        SetTaskToFinish(TaskType.Feed)
//
//        if isInTask && isUnfinished{
//            //将完成置为true
//
//
//
//        }
        
        
        //之后，更新数据库
        func decrementAmount(_ amount: String) -> String? {
            guard let intValue = Int(amount) else {
                return nil // return nil if amount is not a valid integer
            }
            let newValue = intValue - 1
            return String(newValue)
        }

        
        
        //匹配吃的食物，给他-1
        for i in 0..<MainViewController.userFoods.count{
            if MainViewController.userFoods[i].foodID == self.foodInCell?.foodID{
                MainViewController.userFoods[i].foodAmount = decrementAmount(MainViewController.userFoods[i].foodAmount)!
                print("MainViewController.userFoods[i]: \(MainViewController.userFoods[i].foodID)\n")
                print("MainViewController.userFoods[i]: \(MainViewController.userFoods[i].foodName)\n")
                print("MainViewController.userFoods[i]: \(MainViewController.userFoods[i].foodAmount)\n")
            }
            
        }
        
        
        //修改userFoods这个数组
        
        
    }
    
}
