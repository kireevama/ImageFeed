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
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
//        enum WebViewConstants {
//            static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
//        }
        
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
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
        
        didUpdateProgressValue(0)
        
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
            if
                let urlComponents = URLComponents(string: url.absoluteString),
                urlComponents.path == "/oauth/authorize/native",
                let items = urlComponents.queryItems,
                let codeItem = items.first(where: { $0.name == "code" })
            {
                print("Code value: \(String(describing: codeItem.value))")
                return codeItem.value
            } else {
                return nil
            }
        }
    
}
