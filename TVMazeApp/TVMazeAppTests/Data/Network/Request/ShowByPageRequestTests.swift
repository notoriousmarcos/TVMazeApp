//
//  ShowByPageRequestTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import XCTest
@testable import TVMazeApp

class ShowByPageRequestTests: XCTestCase {

    func testShowByPageRequest_init_ShouldRetainCorrectValues() {
        // Arrange
        let sut = ShowByPageRequest(page: 1)

        // Assert
        XCTAssertEqual(sut.baseURL, "https://api.tvmaze.com/shows")
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.contentType, "application/json")
        XCTAssertEqual(sut.params as? [String: String], ["page": "1"])
        XCTAssertNil(sut.body)
        XCTAssertNil(sut.headers)
    }

    func testShowByPageRequest_asURLRequest_ShouldReturnURLRequest() {
        // Arrange
        let sut = ShowByPageRequest(page: 1)

        // Act
        let urlRequest = sut.asURLRequest()

        // Assert
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url?.absoluteString, "https://api.tvmaze.com/shows?page=1")
        XCTAssertNil(urlRequest?.httpBody)
        XCTAssertNotNil(urlRequest?.allHTTPHeaderFields)
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Accept"], "application/json")
    }

}
