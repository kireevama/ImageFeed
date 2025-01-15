//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 03.01.2025.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    override func viewDidLoad() {
        loadAuthView()
        
        progressView.progressTintColor = UIColor(named: "YP Black")
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self,
                               forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    // Формирование адреса запроса и загрузка экрана авторизации
    private func loadAuthView() {
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
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate { // Навигационный делегат получает уведомления о навигации пользователя. При его помощи узнаем авторизовался ли пользователь
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            print("Code from navigationAction received: \(code)")
            decisionHandler(.cancel) // Если код получен - отменяем навигационные действия
        } else {
            decisionHandler(.allow) // Если не получен - разрешаем
        }
    }
    
    // Получение кода из redirectUri
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            print("Code value: \(codeItem.value)")
            return codeItem.value
        } else {
            return nil
        }
    }
}
