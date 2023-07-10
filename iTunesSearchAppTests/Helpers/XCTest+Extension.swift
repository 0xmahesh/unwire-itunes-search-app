//
//  XCTest+Extension.swift
//  iTunesSearchAppTests
//
//  Created by Mahesh De Silva on 10/7/2023.
//

import Foundation
import XCTest

extension XCTest {
    func XCTAssertThrowsAsyncError<T: Sendable>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "XCTAssertThrowsAsyncError failed: did not throw an error",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail(message(), file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
}
