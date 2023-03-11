//
//  ForumVC.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import UIKit

class ForumVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
