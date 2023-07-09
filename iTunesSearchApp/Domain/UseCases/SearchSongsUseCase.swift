//
//  SearchSongsUseCase.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation

protocol SearchSongsUseCase {
    func execute(with params: String) async throws -> [Song]?
}

final class StandardSearchSongsUseCase: SearchSongsUseCase {
    
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func execute(with params: String) async throws -> [Song]? {
        return try await searchRepository.fetchSearchResults(for: params)
    }
    
}
