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
    let createdAt: String?
    let description: String?
    var urls: UrlsResult
    let likedByUser: Bool
}

struct UrlsResult: Decodable { // Структура для данных из полей urls
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Photo { // Структура для UI части
    let id: String
    let size: CGSize
    let createdAt: Date?
    let description: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

final class ImagesListService {
    static let shared = ImagesListService()
    private init() {}
    
    private var task: URLSessionTask?
    private(set) var photos: [Photo] = [] // Массив для хранения загруженных фото
    private var lastLoadedPage: Int? // Номер последней скачанной страницы
    private let formatter = ISO8601DateFormatter()
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private func makePhotosRequest(token: String, page: Int) -> URLRequest? {
        guard let baseUrl = URL(string: Constants.defaultBaseURL.absoluteString) else {
            preconditionFailure("Invalid base URL \(RequestError.invalidBaseURL)")
        }
        guard let url = URL(string:
                                "/photos"
                            + "?page=\(page)"
                            + "&&per_page=\(10)",
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
    func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        
                guard task == nil else {
                    task?.cancel()
                    return }
        
        // Здесь получим страницу номер 1, если ещё не загружали ничего,
        // и следующую страницу (на единицу больше), если есть предыдущая загруженная страница
        guard let lastLoadedPage = lastLoadedPage else {
            lastLoadedPage = 0
            return }
        let nextPage = lastLoadedPage + 1
        
        guard let request = makePhotosRequest(token: token, page: nextPage) else {
            return completion(.failure(RequestError.invalidRequest))
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let data):
                for photoResult in data {
                    var date: Date?
                    if let createdDate = photoResult.createdAt {
                        date = self?.formatter.date(from: createdDate)
                    }
                    
                    let photo = Photo(id: photoResult.id, size: (CGSize(width: Double(photoResult.width), height: Double(photoResult.height))), createdAt: date, description: photoResult.description ?? "", thumbImageURL: photoResult.urls.thumb, largeImageURL: photoResult.urls.full, isLiked: photoResult.likedByUser)
                    
                    self?.photos.append(photo)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                    DispatchQueue.main.async {
                        completion(.success(self?.photos ?? []))
                    }
                }
            case .failure(let error):
                print("ProfileService: NetworkError \(error.localizedDescription)")
                completion(.failure(error))
            }
            
        }
        self.task = task // сохраняем task
        task.resume()
    }
    
}

