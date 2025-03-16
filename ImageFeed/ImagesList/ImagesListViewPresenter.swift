//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 16.03.2025.
//

import Foundation

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    
}
