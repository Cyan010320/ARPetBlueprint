//
//  ForumVC.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import UIKit

class ForumVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var posts: [Post] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostTVC", bundle: nil), forCellReuseIdentifier: "PostTVC")

        let urlString = "http://123.249.97.150:8008/getPosts.php"
        guard let url = URL(string: urlString) else {
            // handle invalid URL
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let posts = try decoder.decode([Post].self, from: data)
                self.posts = posts
                print("帖子数：\(self.posts.count)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                // handle received posts
            } catch {
                print("error")
                // handle decoding error
                return
            }
        }

        task.resume()

        
        
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
