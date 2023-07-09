//
//  SearchResponseDTO.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation

struct SearchResponse: Codable {
    let resultCount: Int
    let results: [SearchResultDTO]
}
