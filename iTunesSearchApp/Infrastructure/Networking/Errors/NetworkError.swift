//
//  NetworkError.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case apiError(URLResponse)
    case networkError(URLError)
    case parsingError(DecodingError)
    case unknown
}

extension NetworkError: Equatable {
    public static func == (_ lhs: NetworkError, _ rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case let (.apiError(respL), .apiError(respR)):
            return respL == respR
        case let (.networkError(errorL), .networkError(errorR)):
            return errorL.code == errorR.code
        case let (.parsingError(errorL), .parsingError(errorR)):
            return errorL.errorDescription == errorR.errorDescription
        default:
            return false
        }
    }
}
