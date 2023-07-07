//
//  SearchResultsListViewModel.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation
import Combine

final class SearchResultsListViewModel {
    @Published private(set) var songs: [Song] = []
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let songs = [
                Song(artworkImageUrl: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/48/59/21/485921c3-9372-37ad-9710-953ef447d561/5039060664698.png/60x60bb.jpg",
                     trackName: "Begin Again",
                     artistName: "Ben Bohmer",
                     shortDescription: "Album - Begin Again (2021)"),
                Song(artworkImageUrl: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/48/59/21/485921c3-9372-37ad-9710-953ef447d561/5039060664698.png/60x60bb.jpg",
                     trackName: "Song 2",
                     artistName: "Artist 2",
                     shortDescription: "Description 2")
            ]
            
            self.songs = songs
        }
    }
}
