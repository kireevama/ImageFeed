//
//  WebViewViewControllerDelegateProtocol.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 03.01.2025.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
