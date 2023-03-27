//
//  SelectPetVC.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/9.
//

import UIKit

class SelectPetVC: UIViewController {

    @IBAction func StartBtn(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "myData_IsFirstLoad")
        defaults.synchronize()
        //确定宠物id
        
        //此外，要把该用户的信息传到数据库
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
