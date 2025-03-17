//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 16.03.2025.
//

import Foundation

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    func viewDidLoad()
    func getImages()
    func changeLike(for photo: Photo, completion: @escaping (Result<Bool, Error>) -> Void)
    func updateTableViewAnimated()
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private var imagesListService: ImagesListServiceProtocol?
    var photos: [Photo] = []
    
    init(imagesListService: ImagesListServiceProtocol? = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                
                self.updateTableViewAnimated()
            }
        
        getImages()
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        guard let newCount = imagesListService?.photos.count else { return }
        guard let photos = imagesListService?.photos else { return }
        self.photos = photos
        
        if oldCount != newCount {
            view?.oldCount = oldCount
            view?.newCount = newCount
            self.view?.updateTableViewAnimated()
        } else {
            return
        }
    }
    
    func getImages() {
        imagesListService?.fetchPhotosNextPage()
    }
    
    func changeLike(for photo: Photo, completion: @escaping (Result<Bool, Error>) -> Void) {
        let newLike = !photo.isLiked
        imagesListService?.changeLike(photoId: photo.id, isLike: newLike) { result in
            switch result {
            case .success:
                completion(.success(newLike))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
