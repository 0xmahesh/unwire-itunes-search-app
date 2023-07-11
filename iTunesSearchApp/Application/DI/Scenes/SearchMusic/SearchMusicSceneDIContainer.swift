//
//  SearchMusicSceneDIContainer.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import UIKit
import SwiftUI

final class SearchMusicSceneDIContainer: SearchMusicFlowDependencyProviding {
    
    private let searchRepository: SearchRepository
    private let imageRepository: ImageRepository
    
    init(searchRepository: SearchRepository, imageRepository: ImageRepository) {
        self.searchRepository = searchRepository
        self.imageRepository = imageRepository
    }
    
    func makeFetchImageUseCase() -> StandardFetchImageUseCase {
        return StandardFetchImageUseCase(imageRepository: imageRepository)
    }
    
    func makeSearchSongsUseCase() -> StandardSearchSongsUseCase {
        return StandardSearchSongsUseCase(searchRepository: searchRepository)
    }
    
    func makeSearchResultsListViewModel() -> SearchResultsListViewModel {
        return SearchResultsListViewModel(searchSongsUseCase: makeSearchSongsUseCase(), fetchImagesUseCase: makeFetchImageUseCase())
    }
    
    func makeSearchResultsViewController(with viewModel: SearchResultsListViewModel) -> SearchResultsListViewController {
        return SearchResultsListViewController(viewModel: makeSearchResultsListViewModel())
    }
    
    func makeSearchMusicFlowCoordinator(navigationController: UINavigationController) -> SearchMusicFlowCoordinator {
        return SearchMusicFlowCoordinator(navigationController: navigationController, dependencyProvider: self)
    }
    
    func makeSongDetailViewModel(with song: Song) -> SongDetailViewModel {
        return SongDetailViewModel(song: song)
    }
    
    func makeSongDetailHostingController(with song: Song) -> UIViewController {
        return UIHostingController(rootView: SongDetailView(viewModel: self.makeSongDetailViewModel(with: song)))
    }
}
