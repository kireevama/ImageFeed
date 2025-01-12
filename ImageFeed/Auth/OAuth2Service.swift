//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 06.01.2025.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    var accessToken: String
    
    enum CodingKays: String, CodingKey {
        case accessToken = "access_token"
    }
}
    
    final class OAuth2Service {
        static let shared = OAuth2Service()
        private init() {}
        
        let oauth2TokenStorage = OAuth2TokenStorage()
        
        private enum ParsingJSONServiceError: Error {
            case invalidJson
            case incorrectObject
        }
        
        private enum RequestError: Error {
            case invalidbaseURL
            case invalidURLComponents
            case badRequest
        }
        
        // Создание запроса для получения токена
        private func makeOAuthTokenRequest(code: String) -> URLRequest {
            guard let baseURL = URL(string: "https://unsplash.com") else {
                preconditionFailure("Invalid base URL \(RequestError.invalidbaseURL)")
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
            request.httpMethod = "POST"
            return request
        }
        
        // Отправка запроса на получение токена и обработка ответа
        func fetchOAuthToken(code: String, handler: @escaping(Result<String, Error>) -> Void) {
            let request = makeOAuthTokenRequest(code: code)
            let task = URLSession.shared.data(for: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        self.oauth2TokenStorage.token = response.accessToken
                        handler(.success(response.accessToken))
                    } catch {
                        print("Parsing JSON error \(ParsingJSONServiceError.invalidJson)")
                    }
                case .failure(let error):
                    print("Network error \(error)")
                    handler(.failure(error))
                }
            }
            task.resume()
        }
    }

