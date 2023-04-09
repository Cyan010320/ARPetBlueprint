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
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTVC", for: indexPath) as! PostTVC
        let post = self.posts[indexPath.row]
        let userID = "1"//后期再改
        //cell.userImage = post.userImg
        //形如：http://123.249.97.150:8008/img/user1.jpg
        loadImage(from: "http://123.249.97.150:8008/img/user\(userID).jpg") { image in
            if let image = image {
                cell.userImage.image = image
            } else {
                cell.userImage.image = UIImage(named: "cookie")
                // Failed to load the image
            }
        }

        cell.userName.text = post.userName
        cell.titleView.text = post.title
        cell.textView.text = post.text
        
        //这个循环应该在加载完之后调用
        DispatchQueue.global().async {
            let imgs = [cell.postImg1, cell.postImg2, cell.postImg3]
            for i in 1...3{
                //形如：http://123.249.97.150:8008/post/post1/img1.PNG
                loadImage(from: "http://123.249.97.150:8008/post/post\(post.postID)/img\(i).PNG", scale: 0.01) { image in
                    print("http://123.249.97.150:8008/post/post\(post.postID)/img\(i).PNG")
                    if let image = image {
                        //if (cell.postImg1.image == UIImage(named: "defaultImage")){
                        imgs[i-1]!.image = image
                        //}
//                        else if (cell.postImg2.image == UIImage(named: "defaultImage")){
//                            cell.postImg2.image = image
//                        }
//                        else if (cell.postImg3.image == UIImage(named: "defaultImage")){
//                            cell.postImg3.image = image
//                        }
                        
                        // Do something with the image
                    } else {
                        // Failed to load the image
                    }
                }
                
            }
        }
                

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 304
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
}
