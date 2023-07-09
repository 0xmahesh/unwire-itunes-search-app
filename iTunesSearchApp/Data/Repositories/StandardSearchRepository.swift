//
//  StandardSearchRepository.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation

final class StandardSearchRepository {
    
    private let apiDataSource: APIDataSource
    
    init(apiDataSource: APIDataSource) {
        self.apiDataSource = apiDataSource
    }
}

extension StandardSearchRepository: SearchRepository {
    func fetchSearchResults(for query: String) async throws -> [Song]? {
        let resultsThreshold: Int = 50
        let endpoint: MusicSearchAPIEndpoint = .search(query: query, limit: resultsThreshold)
        return try await apiDataSource.makeRequest(endpoint: endpoint, type: SearchResponse.self).get()?.results.toArray()
    }
}
