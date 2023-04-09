//
//  FoodCollectionViewCell.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/17.
//

import UIKit

protocol ToyCellDelegate: AnyObject {
    func UpdateHappyBar(for id: String)
}


class ToyCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var toyLabel: UILabel!
    var toyInCell: Toy?
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var toyImage: UIImageView!
    
    var delegate: ToyCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        let touchUpInside = UITapGestureRecognizer(target: self, action: #selector(Tease))
        touchUpInside.delegate = self
        self.addGestureRecognizer(touchUpInside)
        
        // Initialization code
    }
    
    static let toyValue: [String: Float] = [
        "1": 20,
        "2": 25,
        "3": 30,
    ]
    
    @objc func Tease(_ sender: UIGestureRecognizer){

        
        //其次，更新UI
        if var number = Int(self.toyInCell!.toyAmount) {
            number -= 1


            if number == 0 {
                let SuperView = self.superview!
                self.removeFromSuperview()
                UIView.animate(withDuration: 0.2) {
                    for view in SuperView.subviews where view.frame.origin.x > self.frame.origin.x {
                        view.frame.origin.x -= self.frame.width
                    }
                }
            }
            self.toyInCell!.toyAmount = String(number)
        }
        
        self.amountLabel.text = "x\(toyInCell!.toyAmount)"
        delegate?.UpdateHappyBar(for: self.toyInCell!.toyID)
        
        //然后，判断任务是否完成
        SetTaskToFinish(TaskType.ShotTogether)
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
        for i in 0..<MainViewController.userToys.count{
            if MainViewController.userToys[i].toyID == self.toyInCell?.toyID{
                MainViewController.userToys[i].toyAmount = decrementAmount(MainViewController.userToys[i].toyAmount)!
            }
            
        }
        
    }
    
}
