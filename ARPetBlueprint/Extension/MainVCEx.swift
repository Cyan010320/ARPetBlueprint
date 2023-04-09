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
import AVFoundation
import Photos

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
        
        
        if UserDefaults.standard.object(forKey: "myData_LastFoodValue") != nil {
            
            let lastFoodValue = UserDefaults.standard.object(forKey: "myData_LastFoodValue") as! Float
            
            foodValue = getBarValue(value: lastFoodValue, false)
            UserDefaults.standard.set(foodValue, forKey: "myData_LastFoodValue")

        } else {
            // The key does not exist in UserDefaults
            
            foodValue = 30
            UserDefaults.standard.set(30, forKey: "myData_LastFoodValue")
        }
        
        print("生命值：\(foodValue)")
        DrawFoodBar(for: foodValue)
        
        
        if UserDefaults.standard.object(forKey: "myData_LastHappyValue") != nil {
            
            let lastHappyValue = UserDefaults.standard.object(forKey: "myData_LastHappyValue") as! Float
            
            happyValue = getBarValue(value: lastHappyValue, true)
            UserDefaults.standard.set(happyValue, forKey: "myData_LastHappyValue")

        } else {
            // The key does not exist in UserDefaults
            
            happyValue = 30
            UserDefaults.standard.set(30, forKey: "myData_LastHappyValue")
        }
        
        DrawHappyBar(for: happyValue)

        closeBagBtn.isHidden = true
        
        
        //在此初始化三个相机按键
        let offsetX = view.frame.maxX
        let padding = 20
        let smallIconEdge = 60
        
        takePhotoBtn.frame = chatBtn.frame.offsetBy(dx: offsetX, dy: 0)
        switchPhotoVideoBtn.frame = CGRect(
            x: padding + Int(offsetX),
            y: Int(takePhotoBtn.frame.minY) + 10,
            width: smallIconEdge,
            height: smallIconEdge)
        switchCameraBtn.frame = CGRect(
            x: Int(offsetX) - padding - smallIconEdge + Int(offsetX),
            y: Int(takePhotoBtn.frame.minY) + 10,
            width: smallIconEdge,
            height: smallIconEdge)
        
        
    }
    
    //对话
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
    func showBloodValue(){
        
    }
    
    func getCameraUIs() -> [UIButton]{
        return [switchPhotoVideoBtn, takePhotoBtn, switchCameraBtn]
        
    }
    
    
    //由上次更新的值-秒*系数
    func getBarValue(value bloodNow: Float,  _ isNeedUpadteDate: Bool, _ coefficient: Float = 0.002) -> Float{
        if let storedLocalTime = UserDefaults.standard.object(forKey: "myData_LocalTimeKey") as? Date {
            // Compare with current time
            let currentTime = Date()
            let timeDifference = currentTime.timeIntervalSince(storedLocalTime)
            let secondsBetween = Int(timeDifference.rounded())

            print("Seconds between local time (\(storedLocalTime)) and current time (\(currentTime)): \(secondsBetween)")
            var blood = bloodNow - Float(secondsBetween) * coefficient
            if(blood < 0){blood=0}
            if(blood > 100){blood=100}
            if isNeedUpadteDate {
                UserDefaults.standard.set(Date(), forKey: "myData_LocalTimeKey")
            }
            return blood
        }
        if isNeedUpadteDate {
            UserDefaults.standard.set(Date(), forKey: "myData_LocalTimeKey")
        }
        return 30.0
    }
    

   
    @objc func leftSwipe() {
        UIView.animate(withDuration: 0.3) {
            // Move buttons to the left
            let UIs : [UIView] = self.getAllUIs()
            for UI in UIs {
                UI.frame.origin.x -= self.view.frame.maxX
            }
            let cameraUIs = self.getCameraUIs()
            for cameraUI in cameraUIs{
                cameraUI.frame.origin.x -= self.view.frame.maxX
                
            }
            
            
        }
        
        
        
        
    }
    
    @objc func rightSwipe() {
        UIView.animate(withDuration: 0.3) {
            // Move buttons to the left
            let UIs: [UIView] = self.getAllUIs()
            for UI in UIs {
                UI.frame.origin.x += self.view.frame.maxX
            }
            
            let cameraUIs = self.getCameraUIs()
            for cameraUI in cameraUIs{
                cameraUI.frame.origin.x += self.view.frame.maxX
                
            }
            // Add new buttons
        }
    }

    @objc func takePhoto(){}
    @objc func switchLens(){}
    @objc func toggleCamera(){}
    
    
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
    
}

//喂食扩展
extension MainViewController{
    func UpdateFoodBar(for id: String) {
        print("食品值： \(FoodCollectionViewCell.foodValue[id]!)")
        foodValue += FoodCollectionViewCell.foodValue[id]!
        if(foodValue>=100){foodValue=100}
        UserDefaults.standard.set(foodValue, forKey: "myData_LastFoodValue")
        DrawFoodBar(for: foodValue)
    }
    
    func UpdateHappyBar(for id: String) {
        happyValue += ToyCollectionViewCell.toyValue[id]!
        if(happyValue>=100){happyValue=100}
        UserDefaults.standard.set(happyValue, forKey: "myData_LastHappyValue")
        DrawHappyBar(for: happyValue)
    }
    
    
    func reloadBagView(for type: OpenType) {
        bagView.subviews.forEach { $0.removeFromSuperview() }
        
        let cellWidth: CGFloat = 100
        let cellHeight: CGFloat = 150
        let margin: CGFloat = 10
        var xPosition: CGFloat = bagView.frame.minX + 10
        switch type{
            
        case .foodBag:
            for food in foods {
                let cell = Bundle.main.loadNibNamed("FoodCollectionViewCell", owner: self, options: nil)?.first as! FoodCollectionViewCell
                cell.delegate = self
                //let cell = UINib(nibName: FoodCollectionViewCell, bundle: nil)
                cell.foodInCell = food
                if cell.foodInCell?.foodAmount != "0"{
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
            }
        case .toyBag:
            for toy in toys {
                let cell = Bundle.main.loadNibNamed("ToyCollectionViewCell", owner: self, options: nil)?.first as! ToyCollectionViewCell
                cell.delegate = self
                cell.toyInCell = toy
                cell.frame = CGRect(x: xPosition, y: 20, width: cellWidth, height: cellHeight)
                cell.toyLabel.text = toy.toyName
                cell.amountLabel.text = "x\(toy.toyAmount)"
                switch toy.toyID{
                case "1": cell.toyImage.image = UIImage(named: "ball")
                case "2": cell.toyImage.image = UIImage(named: "yarnball")
                case "3": cell.toyImage.image = UIImage(named: "catnip")
                default:
                    break
                }
                bagView.addSubview(cell)
                
                xPosition += cellWidth + margin
            }
        }
        
        bagView.contentSize = CGSize(width: xPosition, height: cellHeight)
    }

    public enum OpenType: Int{
        case foodBag = 0, toyBag
        
    }
    
    public static var userFoods: [Food] = []
    public static var userToys : [Toy]  = []
    func openBag(userID: String, for type: OpenType) {
        var urlString: String
        SetTaskToFinish(TaskType.ShareToQQ)
        //var prefix: String
        switch type{
            
        case .foodBag:
            urlString = "http://123.249.97.150:8008/getBag.php?userID=\(userID)"
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
                                return nil
                            }
                            let food = Food(foodID: foodID, foodAmount: foodAmount, foodName: foodName)
                            MainViewController.userFoods.append(food)
                            //print("foodID: \(foodID), foodAmount: \(foodAmount), foodName: \(foodName)")
                            return Food(foodID: foodID, foodAmount: foodAmount, foodName: foodName)
                            //拉取服务器中的食品
                        }

                        DispatchQueue.main.async {
                            // Refresh UI
                            self.reloadBagView(for: OpenType.foodBag)
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }.resume()
            
        case .toyBag:
            urlString = "http://123.249.97.150:8008/getToy.php?userID=\(userID)"
            guard let url = URL(string: urlString) else { return }

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let toysJSON = json["toys"] as? [[String: Any]] {
                        self.toys = toysJSON.compactMap {
                            //print(foodsJSON)
                            //错误在这
                            guard let toyID = $0["toyID"] as? String,
                                  let toyAmount = $0["toyAmount"] as? String,
                                  let toyName = $0["toyName"] as? String else {
                                return nil
                            }
                            let toy = Toy(toyID: toyID, toyAmount: toyAmount, toyName: toyName)
                            MainViewController.userToys.append(toy)
                            //print("foodID: \(foodID), foodAmount: \(foodAmount), foodName: \(foodName)")
                            return Toy(toyID: toyID, toyAmount: toyAmount, toyName: toyName)

                        }

                        DispatchQueue.main.async {
                            // Refresh UI
                            self.reloadBagView(for: OpenType.toyBag)
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }.resume()
        }
        

        
        
    }


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

    func DrawHappyBar(for happyValue: Float) {
        print("happyValue: \(happyValue)")
        let percentage = happyValue / 100.0
        let fillWidth = CGFloat(percentage) * 340
        
        // Set the frame of the fill UIImageView to reflect the fill percentage
        UIView.animate(withDuration: 0.2) {
            self.heartMask.frame = CGRect(
                x: self.heartBackgroundBar.frame.minX,
                y: self.heartBackgroundBar.frame.minY,
                width: fillWidth,
                height: 40)
        }
        
    }
    
}


//任务初始化，数组为isTaskFinished
extension MainViewController{
    func InitTaskState(){
        if let savedDate = UserDefaults.standard.object(forKey: "myData_LocalTimeKey") as? Date {
            let calendar = Calendar.current
            let savedDateComponents = calendar.dateComponents([.year, .month, .day], from: savedDate)
            let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            
            if savedDateComponents.year == todayComponents.year &&
                savedDateComponents.month == todayComponents.month &&
                savedDateComponents.day == todayComponents.day {
                //判断上次登录是否为今天,若是，从UD中加载状态数组。
                if let taskState = UserDefaults.standard.object(forKey: "myData_TaskState") as? Data,
                   let rewardState = UserDefaults.standard.object(forKey: "myData_RewardState") as? Data{
                    // Convert the data object back to a boolean array using NSKeyedUnarchiver
                    if let taskStateArray = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(taskState) as? [Bool],
                       let rewardStateArray = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rewardState) as? [Bool]{
                        // Use the boolean array as needed
                        isTaskFinished = taskStateArray
                        isRewardReceived = rewardStateArray
                    }
                }

            } else {
                //如果上次登录是昨天，此时需要且仅需要刷新任务完成状态，因为任务id在php中由种子刷新
                isTaskFinished = Array(repeating: false, count: 4)
                isRewardReceived = Array(repeating: true, count: 4)
                if let taskState = try? NSKeyedArchiver.archivedData(withRootObject: isTaskFinished, requiringSecureCoding: false), let rewardState = try? NSKeyedArchiver.archivedData(withRootObject: isRewardReceived, requiringSecureCoding: false) {
                    // Store the Data object in UserDefaults using the set(_:forKey:) method
                    
                    UserDefaults.standard.set(taskState, forKey: "myData_TaskState")
                    UserDefaults.standard.set(rewardState, forKey: "myData_RewardState")
                    
                }
                
                
                print("myData_LocalTimeKey is not today")
            }
        } else {
            print("myData_LocalTimeKey not found in UserDefaults")
        }

        
        return
    }
    
}

//视频录制扩展
extension MainViewController{
    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let output = AVCaptureMovieFileOutput()
            captureSession.addOutput(output)
        } catch {
            print("Error setting up capture session: \(error.localizedDescription)")
        }
    }
    
    func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        view.layer.insertSublayer(previewLayer, at: 0)
    }
//    
//    func setupRecordButton() {
//        let recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
//        recordButton.center = CGPoint(x: view.frame.width / 2, y: view.frame.height - 50)
//        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
//        recordButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
//        recordButton.tintColor = .red
//        view.addSubview(recordButton)
//    }
    
//    @objc func recordButtonTapped() {
//        if !isRecording {
//            let outputPath = NSTemporaryDirectory() + "output.mov"
//            outputFileURL = URL(fileURLWithPath: outputPath)
//            captureSession.startRecording(to: outputFileURL!, recordingDelegate: self)
//            isRecording = true
//        } else {
//            captureSession.stopRecording()
//            isRecording = false
//        }
//    }
}


extension MainViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording video: \(error.localizedDescription)")
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
        }) { saved, error in
            if let error = error {
                print("Error saving video: \(error.localizedDescription)")
                return
            }
            
            if saved {
                print("Video saved successfully")
            }
        }
    }
    
}


extension MainViewController{
    func PlayAnimationForPet(_ animationType: PetAnimation, _ mode: AnimationRepeatMode = .none, _ isNeedIdleAnimation: Bool = false) -> Void{
        let cat = boxAnchor.findEntity(named: "cat")!.children[0]
        let animation = cat.availableAnimations[0]
        let animationView = AnimationView(source: animation.definition,
                                          name: "ani",
                                          bindTarget: nil,
                                          blendLayer: 0,
                                          repeatMode: mode,
                                          fillMode: [],
                                          trimStart: getAnimationStartAndEndTime(animationType).0,
                                          trimEnd: getAnimationStartAndEndTime(animationType).1,
                                          trimDuration: nil,
                                          offset: 0,
                                          delay: 0,
                                          speed: 1.0)
        let resource = try! AnimationResource.generate(with: animationView)
        cat.playAnimation(resource, transitionDuration: 0, startsPaused: false)
        //当宠物播放完需要播放的动画后，调整状态。
        if isNeedIdleAnimation{
            switch animationType{
                
            case .伸懒腰:
                <#code#>
            case .趴着:
                <#code#>
            case .坐着伸懒腰:
                <#code#>
            case .喝水:
                <#code#>
            case .吃东西:
                <#code#>
            case .什么都不做:
                <#code#>
            case .向左看一眼:
                <#code#>
            case .趴下伸懒腰:
                <#code#>
            case .短跳:
                <#code#>
            case .跳下去:
                <#code#>
            case .着陆:
                <#code#>
            case .助跑大跳:
                <#code#>
            case .先走后跳:
                <#code#>
            case .蹦高:
                <#code#>
            case .蹦更高:
                <#code#>
            case .趴下:
                <#code#>
            case .长待机起来:
                <#code#>
            case .左转180:
                <#code#>
            case .右转180:
                <#code#>
            case .左转90:
                <#code#>
            case .右转90:
                <#code#>
            case .左转45:
                <#code#>
            case .右转45:
                <#code#>
            case .大跳:
                <#code#>
            case .左跃:
                <#code#>
            case .右跃:
                <#code#>
            case .跳跃收尾:
                <#code#>
            case .坐下:
                <#code#>
            case .坐着待机起身:
                <#code#>
            case .坐下左右看:
                <#code#>
            case .坐后躺:
                <#code#>
            case .躺后起身:
                <#code#>
            case .坐后舔手:
                <#code#>
            case .趴后躺:
                <#code#>
            case .向左走:
                <#code#>
            case .向右走:
                <#code#>
            }
        }
        
    }
    
    
    
    
}
