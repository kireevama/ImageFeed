//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 11.02.2025.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImageUrl
}

struct ProfileImageUrl: Decodable {
    let small: String
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String? // Хранение url profileImage, в случае успешного запроса
    
    private func makeProfileImageRequest(token: String, username: String) -> URLRequest? {
        guard let baseUrl = URL(string: Constants.defaultBaseURL.absoluteString) else {
            preconditionFailure("Invalid base URL \(ErrorsList.RequestError.invalidBaseURL)")
        }
        guard let url = URL(string:
                                "/users/\(username)",
                            relativeTo: baseUrl
        ) else {
            preconditionFailure("Invalid URL Components \(ErrorsList.RequestError.invalidURLComponents)")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeProfileImageRequest(token: token, username: username) else {
            return completion(.failure(ErrorsList.RequestError.invalidRequest))
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let data):
                self?.avatarURL = data.profileImage.small
                completion(.success(data.profileImage.small))
                
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification,
                          object: self,
                          userInfo: ["URL": data.profileImage.small])
            case .failure(let error):
                print("ProfileImageService: NetworkError \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
        
    }
}
