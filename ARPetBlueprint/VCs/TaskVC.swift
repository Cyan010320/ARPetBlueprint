//
//  TaskVC.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import UIKit

let dailyTaskNumber = 4

class TaskVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var dailyTasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = false
        tableView.register(UINib(nibName: "TaskTVC", bundle: nil), forCellReuseIdentifier: "TaskTVC")
        print("怎么事")


        //这里之后要改，先设为1，后期从UserDefaults中取。
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        getDailyTasks("1") { tasks in
            if let tasks = tasks {
                self.dailyTasks = tasks
            } else {print("没任务")}
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let navigationController = self.navigationController,
           navigationController.viewControllers.firstIndex(of: self) == nil {
            navigationController.setNavigationBarHidden(true, animated: animated)
        }
    }
    


}
