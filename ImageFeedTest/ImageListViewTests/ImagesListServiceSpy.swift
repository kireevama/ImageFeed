//
//  ImagesListServiceSpy.swift
//  ImageFeedTest
//
//  Created by Marina Kireeva on 19.03.2025.
//

import ImageFeed
import Foundation

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    var photos: [ImageFeed.Photo] = []
    
    var fetchPhotosNextPageCalled = false
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func deletePhotos() {
        
    }
    
    
}
