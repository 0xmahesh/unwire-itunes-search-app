//
//  SongDetailViewModel.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 11/7/2023.
//

import Foundation

final class SongDetailViewModel: ObservableObject {
    @Published var song: Song
    var albumArtworkUrl: URL {
        URL(string: song.artworkImageUrl)!
    }
    
    init(song: Song) {
        self.song = song
    }
}

