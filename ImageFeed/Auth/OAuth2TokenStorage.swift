//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 11.01.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let storage: KeychainWrapper = .standard
    
    private enum Key: String {
        case tokenKey
    }
    
    var token: String? {
        get {
            storage.string(forKey: Key.tokenKey.rawValue)
        }
        set {
            guard let newValue = newValue else {
                print("newValue is nil")
                return }
            let isSuccess = storage.set(newValue, forKey: Key.tokenKey.rawValue)
            guard isSuccess else {
                print("Не удалось добавить значение токена в Keychain")
                return
            }
        }
    }
}
