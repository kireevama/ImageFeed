//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 11.01.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let storage: KeychainWrapper = .standard

            private enum Keys: String {
                case tokenKey
            }
    
    var token: String? {
        get {
            return storage.string(forKey: Keys.tokenKey.rawValue)
        }
        set {
            guard let newValue = newValue else {
                print("newValue is nil")
                return }
            let isSuccess = storage.set(newValue, forKey: Keys.tokenKey.rawValue)
            guard isSuccess else {
                print("Не удалось добавить значение токена в Keychain")
                return
            }
        }
    }
}
