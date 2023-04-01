//
//  TaskVC.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import UIKit



class TaskVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = false
        tableView.register(UINib(nibName: "TaskTVC", bundle: nil), forCellReuseIdentifier: "TaskTVC")


        //这里之后要改，先设为1，后期从UserDefaults中取。

//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        
        
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
