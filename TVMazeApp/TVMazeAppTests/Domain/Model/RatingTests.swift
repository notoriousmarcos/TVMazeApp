//
//  RatingTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 02/09/21.
//

import XCTest
@testable import TVMazeApp

class RatingTests: XCTestCase {

    func testRating_codable_ShouldEncodeAndDecodeRating() throws {
        // Arrange
        let sut = Rating(average: 10)
        let decoder = JSONDecoder()

        // Act
        guard let data = sut.toData() else {
            XCTFail("Should return a valid data.")
            return
        }
        let decodedValue = try decoder.decode(Rating.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }

}
