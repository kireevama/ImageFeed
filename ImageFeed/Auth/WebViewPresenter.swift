//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 09.03.2025.
//

import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        enum WebViewConstants {
            static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        }
        
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            print("Error unwrap urlComponents")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("Error unwrap url")
            return
        }
        
        let request = URLRequest(url: url)
        view?.load(request: request)
    }
    
    
}
