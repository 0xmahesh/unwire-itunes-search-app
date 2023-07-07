//
//  Song.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation

struct Song: Codable {
    let artworkImageUrl: String
    let trackName: String
    let artistName: String
    let shortDescription: String
}

extension Song: Hashable {}
