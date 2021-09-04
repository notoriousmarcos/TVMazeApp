//
//  ShowByIdRequestTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import XCTest
@testable import TVMazeApp

class ShowByIdRequestTests: XCTestCase {

    func testShowByIdRequest_init_ShouldRetainCorrectValues() {
        // Arrange
        let sut = ShowByIdRequest(id: 1)

        // Assert
        XCTAssertEqual(sut.baseURL, "https://api.tvmaze.com/shows/1")
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.contentType, "application/json")
        XCTAssertNil(sut.params)
        XCTAssertNil(sut.body)
        XCTAssertNil(sut.headers)
    }

    func testShowByIdRequest_asURLRequest_ShouldReturnURLRequest() {
        // Arrange
        let sut = ShowByIdRequest(id: 1)

        // Act
        let urlRequest = sut.asURLRequest()

        // Assert
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url?.absoluteString, "https://api.tvmaze.com/shows/1")
        XCTAssertNil(urlRequest?.httpBody)
        XCTAssertNotNil(urlRequest?.allHTTPHeaderFields)
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Accept"], "application/json")
    }

}
