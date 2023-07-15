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
    private var fetchImageTask: Task<UIImage?, Error>?
    
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
    
    func fetchAlbumArtwork() async -> UIImage? {
        fetchImageTask = makeFetchImageTask()
        do {
            return try await fetchImageTask?.value
        } catch {
            print("error downloading image...")
            return nil
        }
    }
    
    func resetCell() {
        fetchImageTask?.cancel()
    }
    
    private func makeFetchImageTask() -> Task<UIImage?, Error> {
        return Task {
            return Task.isCancelled ? nil : try await fetchImageUseCase.execute(with: imageUrl)
        }
    }
}
