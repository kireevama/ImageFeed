//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 06.01.2025.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let decoder = JSONDecoder()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // Создание запроса для получения токена
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            preconditionFailure("Invalid base URL \(RequestError.invalidBaseURL)")
        }
        
        guard let url = URL(string:
                                "/oauth/token"
                            + "?client_id=\(Constants.accessKey)"
                            + "&&client_secret=\(Constants.secretKey)"
                            + "&&redirect_uri=\(Constants.redirectURI)"
                            + "&&code=\(code)"
                            + "&&grant_type=authorization_code",
                            relativeTo: baseURL
        ) else {
            preconditionFailure("Invalid URL Components \(RequestError.invalidURLComponents)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        return request
    }
    
    // Отправка запроса на получение токена и обработка ответа
    func fetchOAuthToken(code: String, completion: @escaping(Result<String, Error>) -> Void) {
        assert(Thread.isMainThread) // проверка, что код выполняется на главном потоке
        guard lastCode != code else {
            completion(.failure(RequestError.invalidRequest))
            return
        }
        
        task?.cancel()
        
        lastCode = code // сохраняем код из запроса
        guard let request = makeOAuthTokenRequest(code: code) else {
            return completion(.failure(RequestError.invalidRequest))
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let data):
                self?.oauth2TokenStorage.token = data.accessToken
                completion(.success(data.accessToken))
            case .failure(let error):
                print("OAuth2Service: NetworkError \(error.localizedDescription)")
                completion(.failure(error))
                
                self?.task = nil // обнуление task
                self?.lastCode = nil // обнуление lastCode
            }
        }
        self.task = task // сохраняем task
        task.resume()
    }
}
