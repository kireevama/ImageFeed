//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 04.03.2025.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}
