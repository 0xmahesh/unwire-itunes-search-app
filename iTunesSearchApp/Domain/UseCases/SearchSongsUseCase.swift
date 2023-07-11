//
//  SearchSongsUseCase.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation

protocol SearchSongsUseCase {
    func execute(with params: String, page: Int) async throws -> [Song]?
}

final class StandardSearchSongsUseCase: SearchSongsUseCase {
    
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func execute(with params: String, page: Int) async throws -> [Song]? {
        return try await searchRepository.fetchSearchResults(for: params, page: page)
    }
    
}
