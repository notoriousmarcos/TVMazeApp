//
//  ShowLinkTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 02/09/21.
//

import XCTest
@testable import TVMazeApp

class ShowLinkTests: XCTestCase {

    func testShowLink_codable_ShouldEncodeAndDecodeShowLink() throws {
        // Arrange
        let sut = ShowLink(
            current: Link(
                href: "https://api.tvmaze.com/shows/3"
            ),
            previousepisode: Link(
                href: "https://api.tvmaze.com/episodes/631862"
            )
        )
        let decoder = JSONDecoder()

        // Act
        guard let data = sut.toData() else {
            XCTFail("Should return a valid data.")
            return
        }
        let decodedValue = try decoder.decode(ShowLink.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }

}
