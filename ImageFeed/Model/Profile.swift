//
//  Profile.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 04.03.2025.
//

import Foundation

struct Profile { // Структура для использования на UI-слое
    let username: String
    let name: String // Конкантенация имени и фамилии
    let loginName: String? // username с @ вначале
    let bio: String?
}
