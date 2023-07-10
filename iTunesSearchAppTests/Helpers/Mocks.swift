//
//  Extensions.swift
//  iTunesSearchAppTests
//
//  Created by Mahesh De Silva on 9/7/2023.
//

import Foundation

@testable import iTunesSearchApp

extension URL {
    static func mock() -> Self {
        return URL(string: "https://www.google.com")!
    }
}

extension String {
    static func mock() -> Self {
        return "\(Date().description)"
    }
}

extension Int {
    static func mock(min: Int = 0, max: Int = 10) -> Self {
        return .random(in: min ... max)
    }
}

extension URLResponse {
    @objc static func mock() -> URLResponse {
        return URLResponse(url: URL.mock(), mimeType: .mock(), expectedContentLength: .mock(), textEncodingName: nil)
    }
}

extension NSError {
    static func mock() -> Self {
        return .init(domain: String.mock(), code: 1)
    }
}

extension SearchResultDTO {
    static func mock() -> Self {
        return SearchResultDTO(trackName: "Father Ocean (Ben Böhmer Remix)", artistName: "Monolink", collectionName: "Father Ocean - Single", artworkImageUrl: "https://is4-ssl.mzstatic.com/image/thumb/Music115/v4/84/cf/19/84cf19be-1664-445d-e44f-35b097f9fb8f/4251513982130_3000.jpg/100x100bb.jpg", releaseDate: Date.fromISO8601String("2018-12-07T12:00:00Z"))
    }
}

extension SearchResponse {
    static func mock(_ count: Int) -> Self {
        return SearchResponse(resultCount: count, results: Array(repeating: SearchResultDTO.mock(), count: count))
    }
}

private extension Date {
    static func fromISO8601String(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.calendar = .current
        return dateFormatter.date(from: dateString)
    }
}
