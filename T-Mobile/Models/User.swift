//
//  User.swift
//  T-Mobile
//
//  Created by Kevin Tanner on 3/27/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import Foundation

struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case avatarURL = "avatar_url"
        case numberOfRepos = "public_repos"
        case email
        case location
        case joinDate = "created_at"
        case followers
        case following
        case bio
    }
    
    let userName: String
    let avatarURL: String
    let numberOfRepos: Int
    let email: String?
    let location: String?
    let joinDate: String
    let followers: Int
    let following: Int
    let bio: String?
}

struct TopLevel: Codable {
    var items: [SearchUser]
}

struct SearchUser: Codable {
    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case avatarURL = "avatar_url"
    }
    
    let userName: String?
    let avatarURL: String?
}


struct UserRepo: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case forksCount = "forks_count"
        case starCount = "stargazers_count"
    }
    
    let name: String
    let forksCount: Int
    let starCount: Int
}
