//
//  SearchResultDTO+Mapping.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation

extension SearchResultDTO {
    func toDomain() throws -> Song? {
        guard let trackName = trackName,
              let artistName = artistName,
              let collectionName = collectionName,
              let artworkImageUrl = artworkImageUrl,
              let releaseDate = releaseDate else { return nil }
        
        var shortDescription: String {
            if let year = releaseDate.dateComponents().year {
                return year.description + " • " + collectionName
            } else {
                return collectionName
            }
        }
        
        return Song(artworkImageUrl: artworkImageUrl, trackName: trackName, artistName: artistName, shortDescription: shortDescription)
    }
}

extension Array where Element == SearchResultDTO {
    func toArray() -> [Song] {
        do {
            return try compactMap {
                try $0.toDomain()
            }
        } catch {
            return []
        }
        
    }
}

private extension Date {
    func dateComponents() -> DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return components
    }
}
