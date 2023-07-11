//
//  SearchResultsListViewModel.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation
import Combine

enum SearchResultsViewState {
    case isLoading(Bool)
    case updateDataSource([Song])
    case error(SearchResultsError)
}

final class SearchResultsListViewModel {
    private let searchSongsUseCase: SearchSongsUseCase
    private(set) var viewState = PassthroughSubject<SearchResultsViewState, Never>()
    private var searchTask: Task<[Song]?, Error>?
    private var searchTerm: String = ""
    private(set) var songs: [Song] = []
    private var currentPage: Int = 0
    private var totalResults: Int = 0
    private var isFetchingMoreResults: Bool = false
    
    let searchTextFieldDebounceThreshold: Int = 500
    let fetchImagesUseCase: FetchImageUseCase
    
    init(searchSongsUseCase: SearchSongsUseCase, fetchImagesUseCase: FetchImageUseCase) {
        self.searchSongsUseCase = searchSongsUseCase
        self.fetchImagesUseCase = fetchImagesUseCase
    }
    
    @MainActor
    func search(with query: String) async {
        
        guard !query.isEmpty else {
            viewState.send(.updateDataSource([]))
            return
        }
        songs = []
        searchTerm = query
        
        viewState.send(.isLoading(true))
        
        searchTask?.cancel() // cancel in-flight search request.
        currentPage = 0 //reset current page when starting a new search.
        searchTask = makeSearchTask(with: query, page: currentPage)
        
        await executeSearchTask()
        
        viewState.send(.isLoading(false))
    }
    
    @MainActor
    func loadMoreResultsIfNeeded(currentItemIndex: Int) async {
        guard !isFetchingMoreResults,
              currentItemIndex == totalResults - 1 else {
            return
        }
        
        currentPage += 1
        searchTask = makeSearchTask(with: searchTerm, page: currentPage)
        isFetchingMoreResults = true
        await executeSearchTask()
        isFetchingMoreResults = false
    }
    
    func clearResults() {
        resetSearch()
        viewState.send(.updateDataSource([]))
    }
    
    //MARK: Private functions
    
    private func executeSearchTask() async {
        do {
            guard let songs = try await searchTask?.value else {
                return
            }
            if !self.songs.isEmpty {
                self.songs.append(contentsOf: songs)
            } else {
                self.songs = songs
            }
            totalResults = self.songs.count
            viewState.send(.updateDataSource(self.songs))
        } catch {
            viewState.send(.error(.unknown))
        }
    }
    
    private func resetSearch() {
        searchTerm = ""
        self.songs = []
        currentPage = 0
        totalResults = 0
        isFetchingMoreResults = false
        searchTask?.cancel()
        searchTask = nil
    }
    
    private func makeSearchTask(with query: String, page: Int) -> Task<[Song]?, Error> {
        return Task {
            do {
                return Task.isCancelled ? nil : try await searchSongsUseCase.execute(with: query, page: page)
            } catch {
                return nil
            }
        }
    }
    
}

enum SearchResultsError: Error {
    case unknown
    
    var title: String {
        switch self {
        case .unknown:
            return "unknown_error_title".localized
        }
    }
    
    var description: String {
        switch self {
        case .unknown:
            return "unknown_error_desc".localized
        }
    }
}


