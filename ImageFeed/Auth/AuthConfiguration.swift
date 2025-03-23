//
//  Constants.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 06.12.2024.
//

import Foundation

enum Constants {
    static let accessKey = "nBJ0HGRk5HoQvMmVE2fYUarXPEvSEpHHL6lvvRjdbz0"
    static let secretKey = "4IfpSJpalTulN70jhUqmXu60XcO9C2i3y_94jzsikYo"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = {
        guard let url = URL (string: "https://api.unsplash.com") else {
            preconditionFailure("Base URL error")
        }
        return url
    }()
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: Constants.accessKey,
                                     secretKey: Constants.secretKey,
                                     redirectURI: Constants.redirectURI,
                                     accessScope: Constants.accessScope,
                                     defaultBaseURL: Constants.defaultBaseURL,
                                     authURLString: Constants.unsplashAuthorizeURLString)
        }
}
