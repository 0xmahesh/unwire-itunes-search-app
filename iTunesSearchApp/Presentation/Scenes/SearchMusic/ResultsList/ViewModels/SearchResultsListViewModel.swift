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
        //
    }
    
    func clearResults() {
        searchTerm = ""
        viewState.send(.updateDataSource([]))
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
