//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTest
//
//  Created by Marina Kireeva on 19.03.2025.
//

import ImageFeed
import Foundation

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var imagesListService: ImagesListServiceProtocol?
    var view: ImagesListViewControllerProtocol?
    var photos: [ImageFeed.Photo] = []
    
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func getImages() {
        
    }
    
    func changeLike(for photo: ImageFeed.Photo, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func updateTableViewAnimated() {
        
    }
    

}
