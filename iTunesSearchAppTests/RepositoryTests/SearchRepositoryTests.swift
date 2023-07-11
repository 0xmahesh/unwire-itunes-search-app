//
//  SearchRepositoryTests.swift
//  iTunesSearchAppTests
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import XCTest

@testable import iTunesSearchApp

class StandardSearchRepositoryTests: XCTestCase {
    
    var sut: StandardSearchRepository!
    var mockAPIDataSource: MockAPIDataSource!
    
    override func setUp() {
        super.setUp()
        mockAPIDataSource = MockAPIDataSource()
        sut = StandardSearchRepository(apiDataSource: mockAPIDataSource)
    }
    
    override func tearDown() {
        super.tearDown()
        mockAPIDataSource = nil
        sut = nil
    }
    
    func testFetchSearchResults_SuccessfulResponse() async throws {
        // arrange
        let query = "test"
        let mockResponseDTO = SearchResponse.mock(3)
        
        let expectedResult = mockResponseDTO.results.toArray()
        

        mockAPIDataSource.mockResult = .success(mockResponseDTO)
        
        // act
        let searchResults = try await sut.fetchSearchResults(for: query, page: .mock())
        
        // assert
        XCTAssertEqual(searchResults?.count, expectedResult.count)
        XCTAssertEqual(searchResults?.first?.trackName, expectedResult.first?.trackName)
    }
    
    func testFetchSearchResults_FailureResponse() async {
        // arrange
        let query = "test"
        
        let expectedError = NetworkError.networkError(URLError(.unknown))
        
        mockAPIDataSource.mockResult = .failure(expectedError)
        
        // act
        await XCTAssertThrowsAsyncError(
            try await sut.fetchSearchResults(for: query, page: .mock()),
            "Doesn't throw"
        ) { error in
            // assert
            XCTAssertEqual(error as! NetworkError, expectedError)
        }
    }
}


final class MockAPIDataSource: APIDataSource {
    var mockResult: Result<Any?, NetworkError>?
    
    func makeRequest<T: Decodable>(endpoint: APIEndpoint, type: T.Type) async -> Result<T?, NetworkError> {
        guard let result = mockResult else {
            XCTFail("Mock result not set")
            return .failure(.unknown)
        }
        
        switch result {
        case .success(let value):
            if let typedValue = value as? T {
                return .success(typedValue)
            } else {
                XCTFail("Mock response type mismatch")
                return .failure(.parsingError(.typeMismatch(T.Type.self, .init(codingPath: [], debugDescription: ""))))
            }
            
        case .failure(let error):
            return .failure(error)
        }
    }
}



