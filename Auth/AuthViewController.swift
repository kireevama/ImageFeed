//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 03.01.2025.
//

import UIKit

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    override func viewDidLoad() {
        configureBackButton()
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
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
        // TODO: process code
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
