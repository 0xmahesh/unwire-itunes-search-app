//
//  Song.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation

struct Song: Codable, Identifiable, Hashable {
    var id = UUID()
    let artworkImageUrl: String
    let trackName: String
    let artistName: String
    let shortDescription: String
    
    var highresImageUrl: String {
        return artworkImageUrl.replacingOccurrences(of: "100x100bb", with: "600x600bb")
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(trackName)
        hasher.combine(artistName)
    }
    
    static func ==(lhs: Song, rhs: Song) -> Bool {
        return lhs.id == rhs.id &&
        lhs.artistName == rhs.artistName &&
        lhs.trackName == rhs.trackName
    }
}
