//
//  SearchRepository.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 6/7/2023.
//

import Foundation

protocol SearchRepository {
    func fetchSearchResults(for query: String) async throws -> [Song]?
}
