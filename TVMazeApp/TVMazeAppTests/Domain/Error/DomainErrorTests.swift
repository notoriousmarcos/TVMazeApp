//
//  DomainErrorTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 02/09/21.
//

import XCTest
@testable import TVMazeApp

class DomainErrorTests: XCTestCase {

    func testDomainError_initWithRawValue_ShouldReceiveCorrectError() {
        XCTAssertEqual(DomainError(rawValue: 1), .invalidUrl)
        XCTAssertEqual(DomainError(rawValue: 2), .dataNotFound)
        XCTAssertEqual(DomainError(rawValue: 3), .lastPageAchieved)
        XCTAssertEqual(DomainError(rawValue: 4), .parseFailed)
        XCTAssertEqual(DomainError(rawValue: 5), .rateLimitAchieved)
        XCTAssertEqual(DomainError(rawValue: -1), .unknown)
    }
}
