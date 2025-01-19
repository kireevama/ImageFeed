//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 11.01.2025.
//

import Foundation

final class OAuth2TokenStorage {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            return storage.string(forKey: Keys.token.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
