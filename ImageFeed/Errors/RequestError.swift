//
//  ErrorsList.swift
//  ImageFeed
//
//  Created by Marina Kireeva on 11.02.2025.
//

import Foundation

enum RequestError: Error {
    case invalidRequest
    case invalidBaseURL
    case invalidURLComponents
    case badRequest
}

