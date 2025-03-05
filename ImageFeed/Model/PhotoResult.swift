//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 04.03.2025.
//

import Foundation

struct PhotoResult: Decodable { // Структура ответа от Unsplash
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
}

struct UrlsResult: Decodable { // Структура для данных из полей urls
    let thumb: String
    let full: String
}
