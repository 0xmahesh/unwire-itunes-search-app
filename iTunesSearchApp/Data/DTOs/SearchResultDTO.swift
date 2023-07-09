//
//  SearchResultDTO.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation

struct SearchResultDTO: Codable {
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artworkImageUrl: String?
    let releaseDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case artistName
        case collectionName
        case artworkImageUrl = "artworkUrl100"
        case releaseDate
    }
}
