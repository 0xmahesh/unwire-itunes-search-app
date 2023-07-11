//
//  URLSessionHTTPClientTests.swift
//  iTunesSearchAppTests
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation
import XCTest

@testable import iTunesSearchApp

class URLSessionHTTPClientTests: XCTestCase {
    
    var sut: URLSessionHTTPClient!
    var mockURLSession: URLSession!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        mockURLSession = URLSession(configuration: configuration)
        sut = URLSessionHTTPClient(with: mockURLSession)
    }
    
    override func tearDown() {
        mockURLSession = nil
        sut = nil
        super.tearDown()
    }
    
    func test_executeRequestWithJSONDecoding_returns_Success() async throws {
        // arrange
        let endpoint = MusicSearchAPIEndpoint.search(query: "query", limit: .mock(), offset: .mock())
        let expectedResponseBody = SearchResponse(resultCount: 1, results: [.mock()])
        let expectedResponse = HTTPURLResponse(url: endpoint.url!, statusCode: 200 , httpVersion: nil, headerFields: nil)!
        let jsonString = String.mockJsonString
        let jsonData = jsonString.data(using: .utf8)

        MockURLProtocol.requestHandler = { request in
          return (expectedResponse, jsonData)
        }
        
        // act
        let response = await sut.executeRequestWithJSONDecoding(endpoint, for: SearchResponse.self)
        
        // assert
        switch response {
        case .success(let(responseBody, urlResponse)):
            XCTAssertEqual(responseBody, expectedResponseBody)
            XCTAssertEqual(urlResponse.url, expectedResponse.url)
        case .failure(let error):
            XCTFail("Expected a successful response, but received an error: \(error)")
        }
    }
    
    func test_executeRequestWithJSONDecoding_withInvalidURL_returns_Failure() async throws {
        // arrange
        let endpoint = FakeAPIEndpoint.failure
        MockURLProtocol.requestHandler = { request in
            throw NetworkError.invalidURL
        }
        
        // act
        let response = await sut.executeRequestWithJSONDecoding(endpoint, for: SearchResponse.self)
        
        // assert
        switch response {
        case .success:
            XCTFail("Expected an invalidURL error, but received a successful response.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidURL)
        }
    }
    
    func test_executeRequestWithJSONDecoding_networkError_returns_Failure() async throws {
        // arrange
        let endpoint = FakeAPIEndpoint.success
        MockURLProtocol.requestHandler = { request in
            throw URLError(.notConnectedToInternet)
        }
        
        // act
        let response = await sut.executeRequestWithJSONDecoding(endpoint, for: SearchResponse.self)
        
        // assert
        switch response {
        case .success:
            XCTFail("Expected a URL network error, but received a successful response.")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError.networkError(URLError(.notConnectedToInternet)))
        }
    }
    
}

private enum FakeAPIEndpoint: APIEndpoint {
    case success
    case failure
    
    var host: String { " "}
    var scheme: iTunesSearchApp.HTTPScheme { .https }
    var httpMethod: iTunesSearchApp.HTTPMethod { .get }
    var headers: [String : String] { [:] }
    var queryParams: [String : Any] { [:] }
    var path: String { "" }
    var url: URL? {
        switch self {
        case .failure:
            return nil
        default:
            return URL(string: "https://www.google.com")
        }
    }
    
}

private class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
          }
            
          do {
            let (response, data) = try handler(request)
              
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = data {
              client?.urlProtocol(self, didLoad: data)
            }
            
            client?.urlProtocolDidFinishLoading(self)
          } catch {
            client?.urlProtocol(self, didFailWithError: error)
          }
    }
    
    override func stopLoading() {
        
    }
}

private extension String {
    static let mockJsonString = """
        {
         "resultCount":1,
         "results": [
        {"wrapperType":"track", "kind":"song", "artistId":871821018, "collectionId":1441667866, "trackId":1441667873, "artistName":"Monolink", "collectionName":"Father Ocean - Single", "trackName":"Father Ocean (Ben Böhmer Remix)", "collectionCensoredName":"Father Ocean - Single", "trackCensoredName":"Father Ocean (Ben Böhmer Remix)", "artistViewUrl":"https://music.apple.com/dk/artist/monolink/871821018?uo=4", "collectionViewUrl":"https://music.apple.com/dk/album/father-ocean-ben-b%C3%B6hmer-remix/1441667866?i=1441667873&uo=4", "trackViewUrl":"https://music.apple.com/dk/album/father-ocean-ben-b%C3%B6hmer-remix/1441667866?i=1441667873&uo=4",
        "previewUrl":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/2b/2b/55/2b2b5510-f1f6-9b43-8631-522149f75ff9/mzaf_8899307721232178010.plus.aac.p.m4a", "artworkUrl30":"https://is4-ssl.mzstatic.com/image/thumb/Music115/v4/84/cf/19/84cf19be-1664-445d-e44f-35b097f9fb8f/4251513982130_3000.jpg/30x30bb.jpg", "artworkUrl60":"https://is4-ssl.mzstatic.com/image/thumb/Music115/v4/84/cf/19/84cf19be-1664-445d-e44f-35b097f9fb8f/4251513982130_3000.jpg/60x60bb.jpg", "artworkUrl100":"https://is4-ssl.mzstatic.com/image/thumb/Music115/v4/84/cf/19/84cf19be-1664-445d-e44f-35b097f9fb8f/4251513982130_3000.jpg/100x100bb.jpg", "collectionPrice":12.00, "trackPrice":10.00, "releaseDate":"2018-12-07T12:00:00Z", "collectionExplicitness":"notExplicit", "trackExplicitness":"notExplicit", "discCount":1, "discNumber":1, "trackCount":2, "trackNumber":2, "trackTimeMillis":476193, "country":"DNK", "currency":"DKK", "primaryGenreName":"Electronica", "isStreamable":true}]
        }
        """
}


