//
//  navC.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import UIKit

class navC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if !checkIfFirstLoad() {
//            super.viewDidAppear(animated)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let newViewController = storyboard.instantiateViewController(withIdentifier: "MainVC") as? MainViewController {
//                self.pushViewController(newViewController, animated: false)
//                //self.navigationController?.pushViewController(newViewController, animated: false)
//            }
//
//        }
//    }
    
    override func loadView() {
        
        //去掉这句话，直接崩溃，不知道为啥
        UserDefaults.standard.set(0, forKey: "myData_IsFirstLoad")
        
        
        if !checkIfFirstLoad() {
            super.loadView()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let newViewController = storyboard.instantiateViewController(withIdentifier: "MainVC") as? MainViewController {
                self.pushViewController(newViewController, animated: false)
                //self.navigationController?.pushViewController(newViewController, animated: false)
            }
            
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
