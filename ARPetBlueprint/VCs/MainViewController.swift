//
//  ViewController.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/8.
//

import UIKit
import ARKit
import RealityKit
import AVFoundation
import Speech
import Alamofire

class MainViewController: UIViewController, UIGestureRecognizerDelegate, SFSpeechRecognizerDelegate, UIScrollViewDelegate, FeedCellDelegate {

    

    
    var foodValue:  Float = 0
    var happyValue: Int = 0
    var isHidingUI = false
    let hpLength = 340
    
    
    //语音识别模块
    var speechRecognizer: SFSpeechRecognizer?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    //语音识别模块
    
    var startStepCount: Double = 0
    var endStepCount:   Double = 0
    
    //喂食变量
    var foods: [Food] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadResource()
        //关闭了文本栏
        //speechText.isHidden = true
        
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        initUI()
        if UserDefaults.standard.object(forKey: "myData_LastFoodValue") != nil {
            // The key exists in UserDefaults
            //print("哈哈哈")
            let lastFoodValue = UserDefaults.standard.object(forKey: "myData_LastFoodValue") as! Float
            
            foodValue = updateBloodValue(value: lastFoodValue)
            UserDefaults.standard.set(foodValue, forKey: "myData_LastFoodValue")

        } else {
            // The key does not exist in UserDefaults
            
            foodValue = 30
            UserDefaults.standard.set(30, forKey: "myData_LastFoodValue")
        }
        print("生命值：\(foodValue)")
        DrawFoodBar(for: foodValue)
        
        closeBagBtn.isHidden = true
        let boxAnchor = try! Experience.loadBox()
        arView.scene.anchors.append(boxAnchor)
        let cat = boxAnchor.findEntity(named: "cat")
        //print("动画：\(cat?.availableAnimations[0].definition)")
//        if #available (iOS 14.0, *) {
//            getStepCount { stepCount in
//                // use the step count value here
//                self.startStepCount = stepCount
//            }
//            Thread.sleep(forTimeInterval: 0.05)
//            speechText.text = String(startStepCount)
//        }
        
        //加载血条
        //
        
        
        
        //语音识别模块
        let defaults = UserDefaults.standard
        defaults.set("zh-CN", forKey: "myData_Locale")
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: defaults.object(forKey: "myData_Locale") as! String))!
        
        
        //添加左划效果
        let leftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        leftGestureRecognizer.direction = .left
        self.view.addGestureRecognizer(leftGestureRecognizer)
        
        //添加右划效果
        let rightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe))
        rightGestureRecognizer.direction = .right
        self.view.addGestureRecognizer(rightGestureRecognizer)
        
        
        //为对话添加长按效果
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(holdOnToSpeak(_:)))
        longPressRecognizer.minimumPressDuration = 0.5
        chatBtn.addGestureRecognizer(longPressRecognizer)
        
    }
    
    
    
    
    
    
    
    var walkBtnStatusNow = walkBtnStatus.readyToStart
    //点击遛猫按钮发生的事件
    @IBAction func clickWalk(_ sender: Any) {
        switch walkBtnStatusNow {
        case .readyToStart:
            walkBtnStatusNow = walkBtnStatus.readyToEnd
            walkBtn.setTitle("结束", for: .normal)
            if #available (iOS 14.0, *) {
                getStepCount { stepCount in
                    // use the step count value here
                    self.startStepCount = stepCount
                }
                Thread.sleep(forTimeInterval: 0.05)
                let defaults = UserDefaults.standard
                defaults.set(startStepCount, forKey: "myData_StartStepCount")
                speechText.text = String(startStepCount)
//                getStepCount { stepCount in
//                    // use the step count value here
//                    self.startStepCount = stepCount
//
//                    DispatchQueue.main.async {
//                        let defaults = UserDefaults.standard
//                        defaults.set(self.startStepCount, forKey: "startStepCount")
//                        self.speechText.text = String(self.startStepCount)
//                    }
//                }

            }
            let warningLabel: UILabel = {
                let label = UILabel()
                label.text = "开始计步，当前步数\(startStepCount)"
                label.font = UIFont.systemFont(ofSize: 16)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.isHidden = true
                return label
            }()
            view.addSubview(warningLabel)

            // Add constraints to center the label horizontally and vertically
            NSLayoutConstraint.activate([
                warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                warningLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])

            warningLabel.isHidden = false
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut], animations: {
                warningLabel.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: 1.0, delay: 2.0, options: [.curveEaseInOut], animations: {
                    warningLabel.alpha = 0.0
                }, completion: { _ in
                    warningLabel.isHidden = true
                })
            })
            
        case .readyToEnd:
            walkBtnStatusNow = walkBtnStatus.readyToStart
            walkBtn.setTitle("遛猫", for: .normal)
            //先获取结束时的步数
            if #available (iOS 14.0, *) {
                getStepCount { stepCount in
                    // use the step count value here
                    self.endStepCount = stepCount
                }
                Thread.sleep(forTimeInterval: 0.05)
                let defaults = UserDefaults.standard
                defaults.set(endStepCount, forKey: "myData_EndStepCount")
                speechText.text = String(endStepCount)
            }
            
            let alertController = UIAlertController(title: "遛猫结束！", message: "起始步数：\(startStepCount)\n结束步数：\(endStepCount)\n本次步数：\(endStepCount-startStepCount)", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "好的", style: .default) { (action:UIAlertAction!) in
                // Handle OK button tap
            }

            alertController.addAction(okAction)

            // Present the alert controller
            self.present(alertController, animated: true, completion:nil)

            
            
        }
        
        
    }
    
    @IBAction func closeBag(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bagView.frame.origin.y += 200
            self.closeBagBtn.frame.origin.y += 300
            for button in self.getBottomButtons(){
                button.frame.origin.y -= 300
            }
        })
        //将本次喂食后的所有物品数量发送到服务器
        var sendR: [UserFoodUpdate] = []
        for food in MainViewController.userFoods{
            let change = UserFoodUpdate(userID: "1", foodID: food.foodID, foodAmount: Int(food.foodAmount)!)
            print(change)
            print("\n")
            sendR.append(change)
        }
        
        let url = "http://123.249.97.150:8008/update_user_food.php"
        
        // Encode the sendR array as JSON data
        let jsonData = try! JSONEncoder().encode(sendR)
        
        // Set the HTTP headers and request parameters
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let parameters: Parameters = [
            "updates": jsonData
        ]
        
        
        // Send the POST request using Alamofire
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                
                //print(parameters)
                switch response.result {
                case .success(let value):
                    // Handle success response
                    print("Response: \(value)")
                case .failure(let error):
                    // Handle error response
                    print("更新失败！")
                    
                }
            }
    }
    
    
    @IBAction func clickFeed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: {
            for button in self.getBottomButtons(){
                button.frame.origin.y += 300
            }
        })
        //之后从数据库获取该用户的背包，放进collectionView，浮上来。
        
        
        bagView = UIScrollView(frame: CGRect(
            x: 0,
            y: self.forumBtn.frame.minY,
            width: self.view.frame.maxX,
            height: 190))
        bagView.delegate = self
        bagView.backgroundColor = .white
        
        let closeBtnSize: CGFloat = 40
        closeBagBtn.frame = CGRect(x: view.frame.maxX - closeBtnSize,
                                   y: bagView.frame.minY - closeBtnSize,
                                   width: closeBtnSize,
                                   height: closeBtnSize)
        closeBagBtn.backgroundColor = .systemCyan
        closeBagBtn.layer.cornerRadius = 10
        
        
        //self.view.addSubview(closeBagBtn)
        self.view.bringSubviewToFront(closeBagBtn)
        
        self.view.addSubview(bagView)
        self.view.bringSubviewToFront(bagView)
        // Add your cells as subviews of the UIStackView
        closeBagBtn.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.bagView.frame.origin.y -= 200
            self.closeBagBtn.frame.origin.y -= 200
        })
        
        //从哪获取用户id
        openBag(userID: "1")
        
        
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //全屏view
    @IBOutlet var uiView: UIView!
    @IBOutlet weak var arView: ARView!
    
    
    //顶部UI
    @IBOutlet weak var foodIcon: UIImageView!
    @IBOutlet weak var foodBackgroundBar: UIImageView!
    @IBOutlet weak var foodMask: UIImageView!
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var heartBackgroundBar: UIImageView!
    @IBOutlet weak var heartMask: UIImageView!
    
    //按键UI
    @IBOutlet weak var forumBtn: UIButton!
    @IBOutlet weak var teaseBtn: UIButton!
    @IBOutlet weak var taskBtn: UIButton!
    @IBOutlet weak var feedBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var walkBtn: UIButton!
    
    @IBOutlet weak var speechText: UITextView!
    
    @IBOutlet var bagView: UIScrollView!
    
    @IBOutlet weak var closeBagBtn: UIButton!
    
}

