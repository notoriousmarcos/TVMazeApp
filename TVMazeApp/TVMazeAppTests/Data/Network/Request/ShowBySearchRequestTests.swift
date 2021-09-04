//
//  ShowBySearchRequestTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import XCTest
@testable import TVMazeApp

class ShowBySearchRequestTests: XCTestCase {

    func testShowBySearchRequest_init_ShouldRetainCorrectValues() {
        // Arrange
        let sut = ShowBySearchRequest(search: "search")

        // Assert
        XCTAssertEqual(sut.baseURL, "https://api.tvmaze.com/shows")
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.contentType, "application/json")
        XCTAssertEqual(sut.params as? [String: String], ["q": "search"])
        XCTAssertNil(sut.body)
        XCTAssertNil(sut.headers)
    }

    func testShowBySearchRequest_asURLRequest_ShouldReturnURLRequest() {
        // Arrange
        let sut = ShowBySearchRequest(search: "search")

        // Act
        let urlRequest = sut.asURLRequest()

        // Assert
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url?.absoluteString, "https://api.tvmaze.com/shows?q=search")
        XCTAssertNil(urlRequest?.httpBody)
        XCTAssertNotNil(urlRequest?.allHTTPHeaderFields)
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Accept"], "application/json")
    }

}
