//
//  SearchResultsListItemViewModel.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit

final class SearchResultsListItemViewModel {
    
    private let song: Song
    private let fetchImageUseCase: FetchImageUseCase
    
    var title: String {
        return song.trackName
    }
    
    var subtitle: String {
        return song.artistName
    }
    
    var description: String {
        return song.shortDescription
    }
    
    var imageUrl: URL {
        return URL(string: song.artworkImageUrl)!
    }
    
    init(with song: Song, fetchImageUseCase: FetchImageUseCase) {
        self.song = song
        self.fetchImageUseCase = fetchImageUseCase
    }
}
