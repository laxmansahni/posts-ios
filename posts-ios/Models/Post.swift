//
//  Post.swift
//  posts-ios
//
//  Created by Laxman on 03/05/23.
//

import Foundation

// MARK: - Post
struct Post: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

typealias Posts = [Post]
