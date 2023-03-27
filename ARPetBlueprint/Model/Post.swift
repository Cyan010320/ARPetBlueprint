//
//  Post.swift
//  ARPetBlueprint
//
//  Created by 张思远 on 2023/3/12.
//

import Foundation
import Alamofire

struct Post: Codable{
    var userID: String
    var userName: String
    var userImage: String
    var userPetID: String
    var postID: String
    var title: String
    var postText: String
    var sendTime: String
}


public let postsPerPage: Int = 20

func getPosts(pages: Int, completion: @escaping (Result<[Post], Error>) -> Void) {
    let url = "http://123.249.97.150:8008/pullPosts.php?pages=\(pages)"
    let parameters: [String: Any] = ["pages": pages]

    AF.request(url, parameters: parameters).responseJSON { response in
        switch response.result {
        case .success(let value):
            // Parse JSON response into an array of Post objects
            guard let data = try? JSONSerialization.data(withJSONObject: value),
                  let posts = try? JSONDecoder().decode([Post].self, from: data)
            else {
                completion(.failure(NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])))
                return
            }
            completion(.success(posts))
            
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
