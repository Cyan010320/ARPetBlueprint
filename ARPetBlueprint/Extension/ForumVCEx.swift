//
//  ForumVCEx.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/12.
//

import Foundation
import UIKit

extension ForumVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTVC", for: indexPath) as! PostTVC
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 304
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return postsPerPage
    }
    
    
    
}
