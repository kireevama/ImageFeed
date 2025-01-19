//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 12.01.2025.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    var accessToken: String = ""
    
    private enum CodingKays: String, CodingKey {
        case accessToken = "access_token"
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        accessToken = try container.decode(String.self, forKey: .accessToken)
//    }
}
