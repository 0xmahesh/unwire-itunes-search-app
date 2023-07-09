//
//  StandardAPIDataSource.swift
//  iTunesSearchApp
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation

final class StandardAPIDataSource: APIDataSource {
    private let networkService: HTTPClient
    
    init(networkService: HTTPClient) {
        self.networkService = networkService
    }
    
    func makeRequest<T: Decodable>(endpoint: APIEndpoint, type: T.Type) async -> Result<T?, NetworkError> {
        let response =  await networkService.executeRequestWithJSONDecoding(endpoint, for: type)
        switch response {
        case .success((let responseBody, _)):
            return .success(responseBody)
        case .failure(let error):
            return .failure(error)
        }
    }
}
