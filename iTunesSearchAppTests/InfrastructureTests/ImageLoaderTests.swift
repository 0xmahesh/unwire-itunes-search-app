////
////  ImageLoaderTests.swift
////  iTunesSearchAppTests
////
////  Created by Mahesh De Silva on 9/7/2023.
////
//
//import XCTest
//
//@testable import iTunesSearchApp
//
//class ImageLoaderTests: XCTestCase {
//    
//    var imageLoader: ImageLoader!
//    var mockURLSession: MockURLSession!
//    
//    override func setUp() {
//        super.setUp()
//        mockURLSession = MockURLSession()
//        imageLoader = ImageLoader(urlSession: mockURLSession)
//    }
//    
//    override func tearDown() {
//        super.tearDown()
//        mockURLSession = nil
//        imageLoader = nil
//    }
//    
//    func testFetchImage_Success() async throws {
//        // Given
//        let url = URL(string: "https://example.com/image.jpg")!
//        let image = UIImage(systemName: "photo")!
//        let imageData = image.jpegData(compressionQuality: 1.0)!
//        
//        let response = HTTPURLResponse(
//            url: url,
//            statusCode: 200,
//            httpVersion: nil,
//            headerFields: nil
//        )
//        
//        mockURLSession.mockDataTaskResult = (data: imageData, response: response, error: nil)
//        
//        // When
//        let fetchedImage = try await imageLoader.fetch(url)
//        
//        // Then
//        XCTAssertEqual(fetchedImage, image)
//    }
//    
//    func testFetchImage_Failure() async {
//        // Given
//        let url = URL(string: "https://example.com/image.jpg")!
//        let expectedError = NSError(domain: "Test", code: 123, userInfo: nil)
//        
//        mockURLSession.mockDataTaskResult = (data: nil, response: nil, error: expectedError)
//        
//        // When
//        do {
//            _ = try await imageLoader.fetch(url)
//            XCTFail("Expected an error to be thrown.")
//        } catch {
//            // Then
//            XCTAssertEqual(error as NSError, expectedError)
//        }
//    }
//}
//
////// Mock URLSession for testing
////class MockURLSession: URLSession {
////    
////    var mockDataTaskResult: (data: Data?, response: URLResponse?, error: Error?)?
////    
////    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
////        let data = mockDataTaskResult?.data
////        let response = mockDataTaskResult?.response
////        let error = mockDataTaskResult?.error
////        
////        return MockURLSessionDataTask {
////            completionHandler(data, response, error)
////        }
////    }
////}
//
////// Mock URLSessionDataTask for testing
////class MockURLSessionDataTask: URLSessionDataTask {
////    private let closure: () -> Void
////
////    init(closure: @escaping () -> Void) {
////        self.closure = closure
////    }
////
////    override func resume() {
////        closure()
////    }
////}
//
