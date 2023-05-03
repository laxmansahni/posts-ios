//
//  APIService.swift
//  posts-ios
//
//  Created by Laxman on 03/05/23.
//

import Foundation
import Alamofire

class APIService :  NSObject {
    
    func apiToGetPostData(completion : @escaping (Posts) -> ()){
        let request = AF.request("https://jsonplaceholder.typicode.com/posts")
        request.responseDecodable(of: Posts.self) { response in
            guard let posts = response.value else { return }
            completion(posts)
        }
    }
    
}
