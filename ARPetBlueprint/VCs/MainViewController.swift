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
import Photos

class MainViewController: UIViewController, UIGestureRecognizerDelegate, SFSpeechRecognizerDelegate, UIScrollViewDelegate, FeedCellDelegate, ToyCellDelegate {
    
    var foodValue:  Float = 0
    var happyValue: Float = 0
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
    var toys : [Toy]  = []

    var petCurrentState: PetState = PetState.stand
    
    override func viewWillAppear(_ animated: Bool) {
        loadResource()
        //关闭了文本栏
        speechText.isHidden = true
        
    }

    var idleTimer: Timer?
    var currentIdleAnimationDuration: TimeInterval = 0
    
    let boxAnchor = try! Experience.loadBox()

    func playAnimation(petAnimation: PetAnimation, repeatMode: AnimationRepeatMode = .none){
        print("调用下一个闲置动画")
        let cat = boxAnchor.findEntity(named: "cat")!.children[0]
        let animation = cat.availableAnimations[0]
        let animationView = AnimationView(source: animation.definition,
                                          name: "ani",
                                          bindTarget: nil,
                                          blendLayer: 0,
                                          repeatMode: .none,
                                          fillMode: [],
                                          trimStart: getAnimationStartAndEndTime(petAnimation).0,
                                          trimEnd: getAnimationStartAndEndTime(petAnimation).1,
                                          trimDuration: nil,
                                          offset: 0,
                                          delay: 0,
                                          speed: 1.0)
        let resource = try! AnimationResource.generate(with: animationView)
        cat.playAnimation(resource, transitionDuration: 0, startsPaused: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        initUI()
        
        //加载AR场景
        arView.scene.anchors.append(boxAnchor)
        
        //playAnimation(petAnimation: PetAnimation.大跳)
        

        //cat.playAnimation(resource, transitionDuration: 0, startsPaused: false)
        
        playIdleAnimation()
        

        
        //语音识别模块
        let defaults = UserDefaults.standard
        defaults.set("zh-CN", forKey: "myData_Locale")
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: defaults.object(forKey: "myData_Locale") as! String))!
        
        //屏幕录制模块
        setupCaptureSession()
        setupPreviewLayer()
        
        
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
        
        //初始化任务完成状态，数组在isTaskFinished里存着
        InitTaskState()
        
        //判断今天是否更新了任务，再决定是否调用该闭包
        GetDailyTasks("1") { tasks in
            if let tasks = tasks {
                dailyTasks = tasks
            } else {print("没任务")}
        }
//        for task in dailyTasks{
//            let newTask = TodayTask(taskID: task.taskID, isFinished: false)
//            
//        }
        
        
        
    }
    
    
    var walkBtnStatusNow = WalkBtnStatus.readyToStart
    //点击遛猫按钮发生的事件
    @IBAction func clickWalk(_ sender: Any) {
        switch walkBtnStatusNow {
        case .readyToStart:
            walkBtnStatusNow = WalkBtnStatus.readyToEnd
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
            walkBtnStatusNow = WalkBtnStatus.readyToStart
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
            let stepCountThisTime = endStepCount - startStepCount
            
            let alertController = UIAlertController(title: "遛猫结束！", message: "起始步数：\(startStepCount)\n结束步数：\(endStepCount)\n本次步数：\(stepCountThisTime)", preferredStyle: .alert)
            if(stepCountThisTime >= 1000){
                SetTaskToFinish(TaskType.Walk)
            }
            
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
            let foodAfterChange = UserFoodUpdate(userID: "1", foodID: food.foodID, foodAmount: Int(food.foodAmount)!)
            sendR.append(foodAfterChange)
        }
        
        let url = URL(string: "http://123.249.97.150:8008/updateFoodAmount.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let jsonData = try! JSONEncoder().encode(sendR)
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            do {
                let result = try JSONDecoder().decode([UserFoodUpdate].self, from: data)
                print("输出json：\(result)")
                for foodUpdate in result {
                    if let index = MainViewController.userFoods.firstIndex(where: { $0.foodID == foodUpdate.foodID }) {
                        MainViewController.userFoods[index].foodAmount = String(foodUpdate.foodAmount)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
        
        
        // Send the POST request using Alamofire
        

    }
    
    @IBAction func clickFeed(_ sender: UIButton) {
        
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
        if sender == feedBtn        {openBag(userID: "1", for: OpenType.foodBag)}
        else if sender == teaseBtn  {openBag(userID: "1", for: OpenType.toyBag)}
        
        
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
    
    
    @IBOutlet weak var switchPhotoVideoBtn: UIButton!
    
    @IBOutlet weak var takePhotoBtn: UIButton!
    
    @IBOutlet weak var switchCameraBtn: UIButton!
    
    @IBAction func switchPhotoAndVideo(_ sender: Any) {
        
        if isCameraNow{
            switchPhotoVideoBtn.setImage(UIImage(systemName: "camera"), for: .normal)
            takePhotoBtn.setImage(UIImage(systemName: "video.circle"), for: .normal)
        }
        else{
            switchPhotoVideoBtn.setImage(UIImage(systemName: "video"), for: .normal)
            takePhotoBtn.setImage(UIImage(systemName: "camera.circle"), for: .normal)

        }
        //按下拍照按钮时再判断照相/录像即可，但切换镜头则需要立刻。
        isCameraNow.toggle()
    }
    
    @IBAction func switchLen(_ sender: Any) {
        var config = arView.session.configuration
        switch config {
        case is ARWorldTrackingConfiguration:
            config = ARFaceTrackingConfiguration()
        case is ARFaceTrackingConfiguration:
            config = ARWorldTrackingConfiguration()
        case .none:
            config = ARWorldTrackingConfiguration()
        case .some(_):
            config = ARWorldTrackingConfiguration()
        }
        arView.session.run(config!)
    }
    
    
    
    //let photoOutput = AVCapturePhotoOutput()
    let videoOutput = AVCaptureMovieFileOutput()
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var isRecordingVideo = false
    var outputFileURL: URL?
    // Create a capture session
    var isRecording: Bool = false
    @IBAction func takePhoto(_ sender: Any) {
        if isCameraNow{
            arView.snapshot(saveToHDR: false) { image in
                let imageView = UIImageView()
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
                // set the frame of the image view to whatever size you want
                self.view.addSubview(imageView)
                self.arView.session.pause()
                let shareItems: [Any] = [image!]
                let activityController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                activityController.excludedActivityTypes = [
                    UIActivity.ActivityType.airDrop,
                    UIActivity.ActivityType.copyToPasteboard,
                    UIActivity.ActivityType.message,
                    UIActivity.ActivityType.postToWeibo,
                    UIActivity.ActivityType.saveToCameraRoll]
                self.present(activityController, animated: true){
                    //self.arView.session.run(ARWorldTrackingConfiguration())
                    activityController.completionWithItemsHandler = { activityType, completed, returnedItems, error in
                        // This block will be called when the activity controller is dismissed
                        // Do your work here
                        self.arView.session.run(ARWorldTrackingConfiguration())
                        imageView.removeFromSuperview()
                    }
                    
                }
                
            }
            
            SetTaskToFinish(TaskType.Shot)
        }
        
        else{
            if !isRecordingVideo {
                let outputPath = NSTemporaryDirectory() + "output.mov"
                outputFileURL = URL(fileURLWithPath: outputPath)
                videoOutput.startRecording(to: outputFileURL!, recordingDelegate: self)
                isRecording = true
            } else {
                videoOutput.stopRecording()
                isRecording = false
            }
        }
    }
    
    @IBAction func openForum(_ sender: Any) {
        
        
        
    }
    
    
}

