//
//  RequestTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 04/09/21.
//

import XCTest
@testable import TVMazeApp

class RequestTests: XCTestCase {

    func testRequest_asURLRequestWithHeaderAndBody_ShouldReturnAValidURLRequest() {
        // Arrange
        let sut = MockRequest(body: ["AnyBody": "body"],
                              headers: ["AnyHeader": "header"])

        // Act
        let urlRequest = sut.asURLRequest()

        // Assert
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url?.absoluteString, "http://google.com")
        XCTAssertNotNil(urlRequest?.httpBody)
        XCTAssertNotNil(urlRequest?.allHTTPHeaderFields)
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Accept"], "application/json")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["AnyHeader"], "header")
    }

    func testRequest_asURLRequestWithoutHeaderAndBody_ShouldReturnAValidURLRequest() {
        // Arrange
        let sut = MockRequest(body: nil, headers: nil)

        // Act
        let urlRequest = sut.asURLRequest()

        // Assert
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url?.absoluteString, "http://google.com")
        XCTAssertNil(urlRequest?.httpBody)
        XCTAssertNotNil(urlRequest?.allHTTPHeaderFields)
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(urlRequest?.allHTTPHeaderFields?["Accept"], "application/json")
    }

    private struct MockRequest: Request {
        typealias ReturnType = String

        let baseURL: String = "http://google.com"
        let method: HTTPMethod = .get
        let contentType: String = "application/json"
        let body: [String: Any]?
        let headers: [String: String]?
    }

}
