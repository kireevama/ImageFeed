//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 03.01.2025.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithToken token: String)
}

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "showWebView"
    private let oauth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        configureBackButton()
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
    // Задаем делагата для webView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        self.oauth2Service.fetchOAuthToken(code: code) { result in
            switch result {
            case .success(let token):
                self.delegate?.didAuthenticate(self, didAuthenticateWithToken: token)
                print("Token is received: \(token)")
            case .failure(let error):
                print("Error: Failed to fetch token \(error)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
