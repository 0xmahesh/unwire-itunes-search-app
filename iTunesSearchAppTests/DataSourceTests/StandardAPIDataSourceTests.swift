//
//  StandardAPIDataSourceTests.swift
//  iTunesSearchAppTests
//
//  Created by Mahesh De Silva on 10/7/2023.
//

import Foundation
import XCTest

@testable import iTunesSearchApp

import XCTest

class StandardAPIDataSourceTests: XCTestCase {
    
    var sut: StandardAPIDataSource!
    var mockHTTPClient: MockHTTPClient!
    
    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        sut = StandardAPIDataSource(networkService: mockHTTPClient)
    }
    
    override func tearDown() {
        mockHTTPClient = nil
        sut = nil
        super.tearDown()
    }
    
    func testMakeRequest_Success() async throws {
        // arrange
        let expectedResponseBody = SearchResponse.mock(3)
        let expectedResponse = HTTPURLResponse(url: URL.mock(), statusCode: .mock(), httpVersion: .mock(), headerFields: nil)!
        let expectedResult: Result<SearchResponse?, NetworkError> = .success(expectedResponseBody)
        
        mockHTTPClient.mockResult = .success((expectedResponseBody, expectedResponse))
        
        // act
        let result = await sut.makeRequest(endpoint: MusicSearchAPIEndpoint.search(query: .mock(), limit: .mock()), type: SearchResponse.self)
        
        // assert
        XCTAssertEqual(result, expectedResult)
    }
    
    func testMakeRequest_Failure() async throws {
        // arrange
        let expectedError = NetworkError.networkError(URLError(.notConnectedToInternet))
        let expectedResult: Result<SearchResponse?, NetworkError> = .failure(expectedError)
        
        mockHTTPClient.mockResult = .failure(expectedError)
        
        // act
        let result = await sut.makeRequest(endpoint: MusicSearchAPIEndpoint.search(query: .mock(), limit: .mock()), type: SearchResponse.self)
        
        // assert
        XCTAssertEqual(result, expectedResult)
    }
}

final class MockHTTPClient: HTTPClient {
    
    var mockResult: Result<(Decodable, HTTPURLResponse), NetworkError>?
    
    func executeRequestWithJSONDecoding<ResponseBody: Decodable>(_ endpoint: APIEndpoint, for type: ResponseBody.Type) async -> Result<(ResponseBody, HTTPURLResponse), NetworkError> {
        guard let result = mockResult else {
            XCTFail("Mock result not set")
            return .failure(.unknown)
        }
        
        switch result {
        case .success(let value):
            if let typedValue = value.0 as? ResponseBody {
                return .success((typedValue, value.1))
            } else {
                XCTFail("Mock response type mismatch")
                return .failure(.parsingError(.typeMismatch(ResponseBody.Type.self, .init(codingPath: [], debugDescription: ""))))
            }
            
        case .failure(let error):
            return .failure(error)
        }
    }
}
