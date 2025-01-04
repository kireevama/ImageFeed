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
    @IBOutlet var progressView: UIProgressView!
    
    var progress: Float = 0.5
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        loadAuthView()
        webView.navigationDelegate = self
        progressView.setProgress(progress, animated: true)
        progressView.progressTintColor = UIColor(named: "YP Black")
    }
    
    enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            print("Error unwrap urlComponents")
            return }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        guard let url = urlComponents.url else {
            print("Error unwrap url")
            return }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value                                           
        } else {
            return nil
        }
    }
}
