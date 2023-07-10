//
//  SearchResponseDTO.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation

struct SearchResponse: Codable, Equatable {
    let resultCount: Int
    let results: [SearchResultDTO]
    
    static func == (lhs: SearchResponse, rhs: SearchResponse) -> Bool {
        lhs.resultCount == rhs.resultCount &&
        lhs.results == rhs.results
    }
}
