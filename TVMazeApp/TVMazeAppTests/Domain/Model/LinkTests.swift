//
//  LinkTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 02/09/21.
//

import XCTest
@testable import TVMazeApp

class LinkTests: XCTestCase {

    func testLink_codable_ShouldEncodeAndDecodeLink() throws {
        // Arrange
        let sut = Link(
            href: "https://api.tvmaze.com/shows/3"
        )
        let decoder = JSONDecoder()

        // Act
        guard let data = sut.toData() else {
            XCTFail("Should return a valid data.")
            return
        }
        let decodedValue = try decoder.decode(Link.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }

}
