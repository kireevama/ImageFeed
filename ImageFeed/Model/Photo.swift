//
//  Photo.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 04.03.2025.
//

import Foundation

public struct Photo { // Структура для UI части
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    private static let dateFormatter: ISO8601DateFormatter = {
       ISO8601DateFormatter()
    }()
    
    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = Photo.dateFormatter.date(from: photoResult.createdAt)
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.likedByUser
    }
    
    init(id: String,
         size: CGSize,
         createdAt: Date?,
         welcomeDescription: String?,
         thumbImageURL: String,
         largeImageURL: String,
         isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
}
