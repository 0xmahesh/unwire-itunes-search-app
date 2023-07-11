//
//  SearchResultsListViewModelTests.swift
//  iTunesSearchAppTests
//
//  Created by Mahesh De Silva on 10/7/2023.
//

import XCTest
import Combine
@testable import iTunesSearchApp

class SearchResultsListViewModelTests: XCTestCase {
    
    var viewModel: SearchResultsListViewModel!
    var searchSongsUseCase: MockSearchSongsUseCase!
    var fetchImagesUseCase: MockFetchImageUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        searchSongsUseCase = MockSearchSongsUseCase()
        fetchImagesUseCase = MockFetchImageUseCase()
        viewModel = SearchResultsListViewModel(searchSongsUseCase: searchSongsUseCase,
                                               fetchImagesUseCase: fetchImagesUseCase)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        searchSongsUseCase = nil
        fetchImagesUseCase = nil
        cancellables = nil
    }
    
    func test_search_queryWithEmptyString_updatesDataSourceWithEmptyArray() async throws {
        // arrange
        let expectation = XCTestExpectation(description: "DataSource update expectation")
        viewModel.viewState.sink { state in
            if case .updateDataSource(let songs) = state, songs.isEmpty {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        // act
        await viewModel.search(with: "")
        
        // assert
        wait(for: [expectation], timeout: 1)
    }
    
    func test_search_query_updatesDataSourceWithSongs() async throws{
        // arrange
        let expectation = XCTestExpectation(description: "DataSource update expectation")
        let mockSongs: [Song] = [Song.mock()]
        searchSongsUseCase.executeResult = .success(mockSongs)
        
        viewModel.viewState.sink { state in
            if case .updateDataSource(let songs) = state, songs == mockSongs {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        // act
        await viewModel.search(with: .mock())
        
        // assert
        wait(for: [expectation], timeout: 1)
    }
    
    func test_search_throwsError_updatesViewStateWithError() async throws {
        // arrange
        let expectation = XCTestExpectation(description: "Error state expectation")
        searchSongsUseCase.executeResult = .failure(NetworkError.unknown)

        viewModel.viewState.sink { state in
            if case .error(let error) = state, error == .nilResponse {
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        // act
        await viewModel.search(with: .mock())

        // assert
        wait(for: [expectation], timeout: 1)
    }
    
}

final class MockSearchSongsUseCase: SearchSongsUseCase {
    var executeCalled = false
    var executeResult: Result<[Song]?, Error>?
    
    func execute(with query: String, page: Int) async throws -> [Song]? {
        executeCalled = true
        if let result = executeResult {
            switch result {
            case .success(let songs):
                return songs
            case .failure(let error):
                throw error
            }
        }
        return nil
    }
}

final class MockFetchImageUseCase: FetchImageUseCase {
    func execute(with url: URL) async throws -> UIImage? {
        return nil
    }
}



