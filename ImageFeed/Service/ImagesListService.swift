//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 20.02.2025.
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

struct Photo { // Структура для UI части
    let id: String
    let size: CGSize
    let createdAt: Date
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = ISO8601DateFormatter().date(from: photoResult.createdAt) ?? Date()
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.likedByUser
    }
}

final class ImagesListService {
    static let shared = ImagesListService()
    private init() {}
    
    private var task: URLSessionTask?
    private(set) var photos: [Photo] = [] // Массив для хранения загруженных фото
    private var lastLoadedPage: Int? // Номер последней скачанной страницы
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    private func makePhotosRequest(token: String, page: Int) -> URLRequest? {
        guard let baseUrl = URL(string: Constants.defaultBaseURL.absoluteString) else {
            preconditionFailure("Invalid base URL \(RequestError.invalidBaseURL)")
        }
        guard let url = URL(string:
                                "/photos"
                            + "?page=\(page)",
                            relativeTo: baseUrl
        ) else {
            preconditionFailure("Invalid URL Components \(RequestError.invalidURLComponents)")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
    
    // Функция для получения очередной страницы
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else {
            task?.cancel()
            return }
        
        guard let token = oauth2TokenStorage.token else { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = makePhotosRequest(token: token, page: nextPage) else {
            print("Invalid request in ImagesListService")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResult):
                self?.photos.append(contentsOf: photoResult.map(Photo.init))
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                self?.lastLoadedPage = nextPage
            case .failure(let error):
                print("ProfileService: NetworkError \(error.localizedDescription)")
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func makeLikeRequest(token: String ,photoId: String, isLike: Bool) -> URLRequest {
        guard let url = URL(string: Constants.defaultBaseURL.absoluteString + "/photos/" + photoId + "/like") else {
            preconditionFailure("Invalid base URL \(RequestError.invalidBaseURL)")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if isLike == true {
            request.httpMethod = HTTPMethod.post.rawValue
        } else {
            request.httpMethod = HTTPMethod.delete.rawValue
        }
        
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = oauth2TokenStorage.token else { return }
        
        let request = makeLikeRequest(token: token, photoId: photoId, isLike: isLike)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("[ProfileService]: Ошибка - \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let index = self?.photos.firstIndex(where: { $0.id == photoId }) {
                guard var photo = self?.photos[index] else { return }
                photo.isLiked = !photo.isLiked
                self?.photos[index] = photo
            }
            completion(.success(()))
        }
        task.resume()
    }
    
    func deletePhotos() {
        photos = []
    }
}

