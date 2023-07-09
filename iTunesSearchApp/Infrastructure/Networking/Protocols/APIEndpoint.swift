//
//  APIEndpoint.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation

enum HTTPScheme: String {
    case http
    case https
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}


protocol APIEndpoint {
    var host: String { get }
    var scheme: HTTPScheme { get }
    var httpMethod: HTTPMethod { get }
    var url: URL? { get }
    var headers: [String: String] { get }
    var queryParams: [String: Any] { get }
    var path: String { get }
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension APIEndpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.queryItems = queryParams.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        return components.url
    }
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .iso8601
    }
}
