//
//  WebViewPresenterSpy.swift
//  ImageFeedTest
//
//  Created by Marina Kireeva on 11.03.2025.
//

import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {

    }
    
    func getCode(from url: URL) -> String? {
        return nil
    }
    
}
