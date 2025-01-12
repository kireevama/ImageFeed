//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 11.01.2025.
//

import Foundation

final class OAuth2TokenStorage {
    private let storage: UserDefaults = .standard
    
    let oauth2TokenKey = "oauth2TokenKey"
    
    var token: String? {
        get {
            return storage.string(forKey: oauth2TokenKey)
        }
        set {
            storage.set(newValue, forKey: oauth2TokenKey)
        }
    }
}
