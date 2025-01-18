//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 06.01.2025.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    var access_token = "access_token"
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    let oauth2TokenStorage = OAuth2TokenStorage()
    private let decoder = JSONDecoder()
    
    private enum ParsingJSONServiceError: Error {
        case decodeError
        case invalidJson
        case incorrectObject
    }
    
    private enum RequestError: Error {
        case invalidBaseURL
        case invalidURLComponents
        case badRequest
    }
    
    // Создание запроса для получения токена
    private func makeOAuthTokenRequest(code: String) -> URLRequest {
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
        request.httpMethod = "POST"
        
        print("OAuth2Service url:\(request)")
        return request
    }
    
    // Отправка запроса на получение токена и обработка ответа
    func fetchOAuthToken(code: String, handler: @escaping(Result<String, Error>) -> Void) {
        let request = makeOAuthTokenRequest(code: code)
        let task = URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    guard let response = try self?.decoder.decode(OAuthTokenResponseBody.self, from: data) else { print("Parsing JSON error:\(ParsingJSONServiceError.decodeError)")
                        return
                    }
                    
                    self?.oauth2TokenStorage.token = response.access_token
                    handler(.success(response.access_token))
                } catch {
                    print("Parsing JSON error: \(ParsingJSONServiceError.invalidJson)")
                }
            case .failure(let error):
                print("Network error: \(error)")
                handler(.failure(error))
            }
        }
        
        task.resume()
    }
}

