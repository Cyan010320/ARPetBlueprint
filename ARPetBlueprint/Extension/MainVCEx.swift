//
//  MainVCEx.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import Foundation
import UIKit
import AVFAudio
import Speech
import Alamofire
import RealityKit

extension MainViewController{
    func loadResource(){
        //加载初始变量
        
        
        
        
    }
    func getAllUIs() -> [UIView]{
        let UIs: [UIView] = [foodIcon, foodBackgroundBar, foodMask, heartIcon, heartBackgroundBar, heartMask, forumBtn, teaseBtn, taskBtn, feedBtn, chatBtn, walkBtn, speechText]
        return UIs
    }
    
    func getBottomButtons() -> [UIButton]{
        return [forumBtn, teaseBtn, taskBtn, feedBtn, chatBtn, walkBtn]
    }
    
    func initUI() {
        foodBackgroundBar.layer.cornerRadius = 20
        foodBackgroundBar.alpha = 0.5
        heartBackgroundBar.layer.cornerRadius = 20
        heartBackgroundBar.alpha = 0.5
        
        foodMask.layer.cornerRadius = 20
        heartMask.layer.cornerRadius = 20
    }
    
    func startRecording() throws{
       recognitionTask?.cancel()
       self.recognitionTask = nil
       
       let audioSession = AVAudioSession.sharedInstance()
       try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
       try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
       let inputNode = audioEngine.inputNode
       
       
       recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
       guard let recognitionRequest = recognitionRequest else {
           fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
       }
       recognitionRequest.shouldReportPartialResults = true
       
       if #available(iOS 13, *) {
           recognitionRequest.requiresOnDeviceRecognition = false
           
       }
        recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest) { [self]
           result, error in
           var isFinal = false
           if let result = result {
               //更新识别字
               isFinal = result.isFinal
               print(result.bestTranscription.formattedString)
               speechText.text = result.bestTranscription.formattedString
//               let cat = try! Experience.load(named: "cat")
//               print(cat.availableAnimations[0].name!)
               
               
               
               
               
           }
           if error != nil || isFinal {
               self.audioEngine.stop()
               inputNode.removeTap(onBus: 0)
               
               self.recognitionRequest = nil
               self.recognitionTask = nil
               
               
           }
           
       }
       
       let recordingFormat = inputNode.outputFormat(forBus: 0)
       inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
           self.recognitionRequest?.append(buffer)
       }
       
       audioEngine.prepare()
       try audioEngine.start()
       //调整按钮状态，表示正在录音
       
   }
    
    //喂食相关的函数
    //
    func showBloodValue(){
        
    }
    
    func updateBloodValue(value bloodNow: Float) -> Float{
        if let storedLocalTime = UserDefaults.standard.object(forKey: "myData_LocalTimeKey") as? Date {
            // Compare with current time
            let currentTime = Date()
            let timeDifference = currentTime.timeIntervalSince(storedLocalTime)
            let secondsBetween = Int(timeDifference.rounded())

            print("Seconds between local time (\(storedLocalTime)) and current time (\(currentTime)): \(secondsBetween)")
            var blood = bloodNow - Float(secondsBetween) * 0.002
            if(blood < 0){blood=0}
            UserDefaults.standard.set(Date(), forKey: "myData_LocalTimeKey")
            return blood
        }
        UserDefaults.standard.set(Date(), forKey: "myData_LocalTimeKey")
        return 30
    }
    //
   
    @objc func leftSwipe() {
        UIView.animate(withDuration: 0.3) {
            // Move buttons to the left
            let UIs : [UIView] = self.getAllUIs()
            for UI in UIs {
                UI.frame.origin.x -= self.view.frame.maxX
            }
        }
    }
    
    @objc func rightSwipe() {
        UIView.animate(withDuration: 0.3) {
            // Move buttons to the left
            let UIs : [UIView] = self.getAllUIs()
            for UI in UIs {
                UI.frame.origin.x += self.view.frame.maxX
            }
        }
    }
    
    @objc func holdOnToSpeak(_ sender: UILongPressGestureRecognizer){
        //var i: Int = 0

        if sender.state == .began {
            try! startRecording()
            //开启一个录音线程，在ended中识别。
        } else if sender.state == .ended {
            // 松手会执行的函数
            audioEngine.stop()
            recognitionRequest?.endAudio()
            //speechText.text = text
            //print("长按函数执行")
        }
        
    }
    
//    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
//        let translation = gestureRecognizer.translation(in: bagView)
//        let velocity = gestureRecognizer.velocity(in: bagView)
//
//        if gestureRecognizer.state == .changed {
//            bagView.contentOffset.x -= translation.x
//        } else if gestureRecognizer.state == .ended {
//            let swipeVelocityThreshold: CGFloat = 1500
//            if velocity.x > swipeVelocityThreshold {
//                // User swiped right
//            } else if velocity.x < -swipeVelocityThreshold {
//                // User swiped left
//            } else {
//                // User did not swipe fast enough, return scroll view to original position
//                UIView.animate(withDuration: 0.2) {
//                    self.bagView.contentOffset.x = 0
//                }
//            }
//        }
//
//        gestureRecognizer.setTranslation(CGPoint.zero, in: bagView)
//    }

    
}

//喂食扩展
extension MainViewController{
    //喂食扩展
    func UpdateFoodBar(for id: String) {
        print("食品值： \(FoodCollectionViewCell.foodValue[id]!)")
        foodValue += FoodCollectionViewCell.foodValue[id]!
        if(foodValue>=100){foodValue=100}
        UserDefaults.standard.set(foodValue, forKey: "myData_LastFoodValue")
        DrawFoodBar(for: foodValue)
    }
    
    func reloadBagView() {
        bagView.subviews.forEach { $0.removeFromSuperview() }
        
        let cellWidth: CGFloat = 100
        let cellHeight: CGFloat = 150
        let margin: CGFloat = 10
        var xPosition: CGFloat = bagView.frame.minX + 10
        
        for food in foods {
            let cell = Bundle.main.loadNibNamed("FoodCollectionViewCell", owner: self, options: nil)?.first as! FoodCollectionViewCell
            cell.delegate = self
            //let cell = UINib(nibName: FoodCollectionViewCell, bundle: nil)
            cell.foodInCell = food
            cell.frame = CGRect(x: xPosition, y: 20, width: cellWidth, height: cellHeight)
            cell.foodLabel.text = food.foodName
            cell.amountLabel.text = "x\(food.foodAmount)"
            switch food.foodID{
            case "1": cell.foodImage.image = UIImage(named: "donut")
            case "2": cell.foodImage.image = UIImage(named: "pizza")
            case "3": cell.foodImage.image = UIImage(named: "milktea")
            case "4": cell.foodImage.image = UIImage(named: "icetea")
            case "5": cell.foodImage.image = UIImage(named: "cookie")
            case "6": cell.foodImage.image = UIImage(named: "pumpkin")
            default:
                break
            }
            bagView.addSubview(cell)
            
            xPosition += cellWidth + margin
        }
        
        bagView.contentSize = CGSize(width: xPosition, height: cellHeight)
    }

    public static var userFoods: [Food] = []
    func openBag(userID: String) {
        let urlString = "http://123.249.97.150:8008/getBag.php?userID=\(userID)"
        print(urlString)
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let foodsJSON = json["foods"] as? [[String: Any]] {
                    self.foods = foodsJSON.compactMap {
                        //print(foodsJSON)
                        //错误在这
                        guard let foodID = $0["foodID"] as? String,
                              let foodAmount = $0["foodAmount"] as? String,
                              let foodName = $0["foodName"] as? String else {
                            print("Empty or invalid value for food ID, amount, or name:")
                            print($0)
                            return nil
                        }
                        let food = Food(foodID: foodID, foodAmount: foodAmount, foodName: foodName)
                        MainViewController.userFoods.append(food)
                        print("foodID: \(foodID), foodAmount: \(foodAmount), foodName: \(foodName)")
                        return Food(foodID: foodID, foodAmount: foodAmount, foodName: foodName)
                        //拉取服务器中的食品
                    }

                    DispatchQueue.main.async {
                        // Refresh UI
                        self.reloadBagView()
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }


//    func sendRequest(userID: String, completion: @escaping ([Food]) -> Void) {
//        let urlString = "http://123.249.97.150:8008/getBag.php?userID=\(userID)"
//        AF.request(urlString).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                if let json = value as? [String: Any], let foodsJSON = json["foods"] as? [[String: Any]] {
//                    let foods = foodsJSON.compactMap { foodJSON in
//                        guard let foodID = foodJSON["foodID"] as? Int,
//                              let foodAmount = foodJSON["foodAmount"] as? Int,
//                              let foodName = foodJSON["foodName"] as? String else {
//                                  return nil
//                        }
//                        return Food(id: foodID, name: foodName, amount: foodAmount)
//                    }
//                    completion(foods)
//                } else {
//                    completion([])
//                }
//            case .failure(let error):
//                print("Error: \(error)")
//                completion([])
//            }
//        }
//    }
//
//
    func DrawFoodBar(for foodValue: Float) {
        print("foodValue: \(foodValue)")
        let percentage = foodValue / 100.0
        let fillWidth = CGFloat(percentage) * 340
        
        // Set the frame of the fill UIImageView to reflect the fill percentage
        UIView.animate(withDuration: 0.2) {
            self.foodMask.frame = CGRect(
                x: self.foodBackgroundBar.frame.minX,
                y: self.foodBackgroundBar.frame.minY,
                width: fillWidth,
                height: 40)
        }
        
    }

    
    
}
