//
//  UserResult.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 04.03.2025.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImageUrl
}

struct ProfileImageUrl: Decodable {
    let small: String
}
