//
//  EpisodeTests.swift
//  TVMazeAppTests
//
//  Created by marcos.brito on 01/09/21.
//

import XCTest
@testable import TVMazeApp

class EpisodeTests: XCTestCase {

    func testEpisode_codable_ShouldEncodeAndDecodeEpisode() throws {
        // Arrange
        let sut = Episode(
            id: 1,
            name: "Episode 1",
            number: 1,
            season: 1,
            summary: "Summary",
            image: nil
        )
        let decoder = JSONDecoder()

        // Act
        guard let data = sut.toData() else {
            XCTFail("Should return a valid data.")
            return
        }
        let decodedValue = try decoder.decode(Episode.self, from: data)

        // Assert
        XCTAssertEqual(sut, decodedValue)
    }

}
