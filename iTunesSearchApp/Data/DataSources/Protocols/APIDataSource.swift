//
//  APIDataSource.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation

protocol APIDataSource {
    func makeRequest<T: Decodable>(endpoint: APIEndpoint, type: T.Type) async -> Result<T?, NetworkError>
}
