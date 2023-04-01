//
//  ForumVC.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import UIKit

class ForumVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostTVC", bundle: nil), forCellReuseIdentifier: "PostTVC")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show navigation bar when this view controller disappears
        if let navigationController = self.navigationController,
           navigationController.viewControllers.firstIndex(of: self) == nil {
            // This view controller is disappearing because it's being popped
            // off the navigation stack, not because a new view controller
            // is being pushed on top of it
            navigationController.setNavigationBarHidden(true, animated: animated)
        }
    }
    

}
