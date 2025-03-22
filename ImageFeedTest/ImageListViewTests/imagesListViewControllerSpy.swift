//
//  imagesListViewControllerSpy.swift
//  ImageFeedTest
//
//  Created by Marina Kireeva on 19.03.2025.
//

import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    
    var didUpdateTableViewAnimated = false
    
    func updateTableViewAnimated() {
        didUpdateTableViewAnimated = true
    }
    
    var oldCount: Int = 0
    
    var newCount: Int = 0
    
    
}
