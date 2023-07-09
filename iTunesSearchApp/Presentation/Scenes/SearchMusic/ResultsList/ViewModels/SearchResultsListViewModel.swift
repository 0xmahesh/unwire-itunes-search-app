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
    @Published private(set) var searchTerm: String = ""
    
    let searchTextFieldDebounceThreshold: Int = 500
    let fetchImagesUseCase: FetchImageUseCase
    
    init(searchSongsUseCase: SearchSongsUseCase, fetchImagesUseCase: FetchImageUseCase) {
        self.searchSongsUseCase = searchSongsUseCase
        self.fetchImagesUseCase = fetchImagesUseCase
    }
    
    @MainActor
    func search(with query: String) async {
        searchTerm = query
        
        guard !query.isEmpty else {
            viewState.send(.updateDataSource([]))
            return
        }
        
        viewState.send(.isLoading(true))
        
        searchTask?.cancel() // cancel in-flight search request.
        searchTask = makeSearchTask(with: query)
        
        do {
            if let songs = try await searchTask?.value {
                viewState.send(.updateDataSource(songs))
            }
        } catch {
            viewState.send(.error(.unknown))
        }
        
        viewState.send(.isLoading(false))
    }
    
    func clearResults() {
        searchTerm = ""
        viewState.send(.updateDataSource([]))
    }
    
    private func makeSearchTask(with query: String) -> Task<[Song]?, Error> {
        return Task {
            do {
                return Task.isCancelled ? nil : try await searchSongsUseCase.execute(with: query)
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
