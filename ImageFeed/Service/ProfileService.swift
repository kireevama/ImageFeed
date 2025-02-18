//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 01.02.2025.
//

import Foundation

struct ProfileResult: Decodable { // Структура для декодирования ответа
    var username: String
    var firstName: String
    var lastName: String?
    var bio: String?
}

struct Profile { // Структура для использования на UI-слое
    let username: String
    let name: String // Конкантенация имени и фамилии
    let loginName: String? // username с @ вначале
    let bio: String?
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private(set) var profile: Profile?
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let baseUrl = URL(string: Constants.defaultBaseURL.absoluteString) else {
            preconditionFailure("Invalid base URL \(ErrorsList.RequestError.invalidBaseURL)")
        }
        guard let url = URL(string:
                                "/me",
                            relativeTo: baseUrl
        ) else {
            preconditionFailure("Invalid URL Components \(ErrorsList.RequestError.invalidURLComponents)")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeProfileRequest(token: token) else {
            return completion(.failure(ErrorsList.RequestError.invalidRequest))
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let data):
                let profile = Profile(username: data.username,
                                      name: data.firstName + " " + (data.lastName ?? ""),
                                      loginName: "@" + data.username,
                                      bio: data.bio ?? "")
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("ProfileService: NetworkError \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
