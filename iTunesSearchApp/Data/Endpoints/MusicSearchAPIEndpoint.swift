//
//  MusicSearchAPIEndpoint.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation

enum Region: String {
    case denmark = "dk"
    case srilanka = "lk"
}

enum MusicSearchAPIEndpoint: APIEndpoint {
    case search(query: String, limit: Int)
}

extension MusicSearchAPIEndpoint {
    
    var host: String {
        return "itunes.apple.com"
    }
    
    var scheme: HTTPScheme {
        return .https
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var queryParams: [String : Any] {
        switch self {
        case .search(let query, let limit):
            return ["term": query.replacingOccurrences(of: " ", with: "+"),
                    "country": region.rawValue,
                    "limit": limit]
        }
    }
    
    var region: Region {
        switch self {
        case .search:
            return .denmark
        }
    }
}

